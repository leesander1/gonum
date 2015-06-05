// Copyright ©2015 The gonum Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

package search

import (
	"container/heap"
	"math"

	"github.com/gonum/graph"
	"github.com/gonum/matrix/mat64"
)

// DijkstraFrom returns a shortest-path tree for a shortest path from u to all nodes in
// the graph g. If weight is nil and the graph does not implement graph.Coster, UniformCost
// is used. DijkstraFrom will panic if g has a u-reachable negative edge weight.
func DijkstraFrom(u graph.Node, g graph.Graph, weight graph.CostFunc) Shortest {
	if !g.NodeExists(u) {
		return Shortest{from: u}
	}
	var (
		from   = g.Neighbors
		edgeTo func(graph.Node, graph.Node) graph.Edge
	)
	switch g := g.(type) {
	case graph.DirectedGraph:
		from = g.Successors
		edgeTo = g.EdgeTo
	default:
		edgeTo = g.EdgeBetween
	}
	if weight == nil {
		if g, ok := g.(graph.Coster); ok {
			weight = g.Cost
		} else {
			weight = UniformCost
		}
	}

	nodes := g.NodeList()
	path := newShortestFrom(u, nodes)

	// Dijkstra's algorithm here is implemented essentially as
	// described in Function B.2 in figure 6 of UTCS Technical
	// Report TR-07-54.
	//
	// http://www.cs.utexas.edu/ftp/techreports/tr07-54.pdf
	Q := priorityQueue{{node: u, dist: 0}}
	for Q.Len() != 0 {
		mid := heap.Pop(&Q).(distanceNode)
		k := path.indexOf[mid.node.ID()]
		if mid.dist < path.dist[k] {
			path.dist[k] = mid.dist
		}
		for _, v := range from(mid.node) {
			j := path.indexOf[v.ID()]
			w := weight(edgeTo(mid.node, v))
			if w < 0 {
				panic("dijkstra: negative edge weight")
			}
			joint := path.dist[k] + w
			if joint < path.dist[j] {
				heap.Push(&Q, distanceNode{node: v, dist: joint})
				path.set(j, joint, k)
			}
		}
	}

	return path
}

// DijkstraAllPaths returns a shortest-path tree for shortest paths in the graph g.
// If weight is nil and the graph does not implement graph.Coster, UniformCost is used.
// DijkstraAllPaths will panic if g has a negative edge weight.
func DijkstraAllPaths(g graph.Graph, weight graph.CostFunc) (paths ShortestPaths) {
	var (
		from   = g.Neighbors
		edgeTo func(graph.Node, graph.Node) graph.Edge
	)
	switch g := g.(type) {
	case graph.DirectedGraph:
		from = g.Successors
		edgeTo = g.EdgeTo
	default:
		edgeTo = g.EdgeBetween
	}
	if weight == nil {
		if g, ok := g.(graph.Coster); ok {
			weight = g.Cost
		} else {
			weight = UniformCost
		}
	}

	nodes := g.NodeList()

	indexOf := make(map[int]int, len(nodes))
	for i, n := range nodes {
		indexOf[n.ID()] = i
	}

	dist := make([]float64, len(nodes)*len(nodes))
	for i := range dist {
		dist[i] = math.Inf(1)
	}
	paths = ShortestPaths{
		nodes:   nodes,
		indexOf: indexOf,

		dist:    mat64.NewDense(len(nodes), len(nodes), dist),
		next:    make([][]int, len(nodes)*len(nodes)),
		forward: false,
	}

	var Q priorityQueue
	for i, u := range nodes {
		// Dijkstra's algorithm here is implemented essentially as
		// described in Function B.2 in figure 6 of UTCS Technical
		// Report TR-07-54 with the addition of handling multiple
		// co-equal paths.
		//
		// http://www.cs.utexas.edu/ftp/techreports/tr07-54.pdf

		// Q must be empty at this point.
		heap.Push(&Q, distanceNode{node: u, dist: 0})
		for Q.Len() != 0 {
			mid := heap.Pop(&Q).(distanceNode)
			k := paths.indexOf[mid.node.ID()]
			if mid.dist < paths.dist.At(i, k) {
				paths.dist.Set(i, k, mid.dist)
			}
			for _, v := range from(mid.node) {
				j := paths.indexOf[v.ID()]
				w := weight(edgeTo(mid.node, v))
				if w < 0 {
					panic("dijkstra: negative edge weight")
				}
				joint := paths.dist.At(i, k) + w
				if joint < paths.dist.At(i, j) {
					heap.Push(&Q, distanceNode{node: v, dist: joint})
					paths.set(i, j, joint, k)
				} else if joint == paths.dist.At(i, j) {
					paths.add(i, j, k)
				}
			}
		}
	}

	return paths
}

type distanceNode struct {
	node graph.Node
	dist float64
}

// priorityQueue implements a no-dec priority queue.
type priorityQueue []distanceNode

func (q priorityQueue) Len() int            { return len(q) }
func (q priorityQueue) Less(i, j int) bool  { return q[i].dist < q[j].dist }
func (q priorityQueue) Swap(i, j int)       { q[i], q[j] = q[j], q[i] }
func (q *priorityQueue) Push(n interface{}) { *q = append(*q, n.(distanceNode)) }
func (q *priorityQueue) Pop() interface{} {
	t := *q
	var n interface{}
	n, *q = t[len(t)-1], t[:len(t)-1]
	return n
}
