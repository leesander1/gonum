#!/usr/bin/env bash

# Copyright ©2015 The Gonum Authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

WARNING='//\
// Float32 implementations are autogenerated and not directly tested.\
'

# Level1 routines.

echo Generating level1single.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level1single.go
cat level1double.go \
| gofmt -r 'blas.Float64Level1 -> blas.Float32Level1' \
\
| gofmt -r 'float64 -> float32' \
| gofmt -r 'blas.DrotmParams -> blas.SrotmParams' \
\
| gofmt -r 'f64.AxpyInc -> f32.AxpyInc' \
| gofmt -r 'f64.AxpyIncTo -> f32.AxpyIncTo' \
| gofmt -r 'f64.AxpyUnitary -> f32.AxpyUnitary' \
| gofmt -r 'f64.AxpyUnitaryTo -> f32.AxpyUnitaryTo' \
| gofmt -r 'f64.DotUnitary -> f32.DotUnitary' \
| gofmt -r 'f64.ScalInc -> f32.ScalInc' \
| gofmt -r 'f64.ScalUnitary -> f32.ScalUnitary' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1S\2_" \
      -e 's_^// D_// S_' \
      -e "s_^\(func (Implementation) \)Id\(.*\)\$_$WARNING\1Is\2_" \
      -e 's_^// Id_// Is_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
      -e 's_"math"_math "gonum.org/v1/gonum/internal/math32"_' \
>> level1single.go

echo Generating level1single_sdot.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level1single_sdot.go
cat level1double_ddot.go \
| gofmt -r 'float64 -> float32' \
\
| gofmt -r 'f64.DotInc -> f32.DotInc' \
| gofmt -r 'f64.DotUnitary -> f32.DotUnitary' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1S\2_" \
      -e 's_^// D_// S_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> level1single_sdot.go

echo Generating level1single_dsdot.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level1single_dsdot.go
cat level1double_ddot.go \
| gofmt -r '[]float64 -> []float32' \
\
| gofmt -r 'f64.DotInc -> f32.DdotInc' \
| gofmt -r 'f64.DotUnitary -> f32.DdotUnitary' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1Ds\2_" \
      -e 's_^// D_// Ds_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> level1single_dsdot.go

echo Generating level1single_sdsdot.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level1single_sdsdot.go
cat level1double_ddot.go \
| gofmt -r 'float64 -> float32' \
\
| gofmt -r 'f64.DotInc(x, y, f(n), f(incX), f(incY), f(ix), f(iy)) -> alpha + float32(f32.DdotInc(x, y, f(n), f(incX), f(incY), f(ix), f(iy)))' \
| gofmt -r 'f64.DotUnitary(a, b) -> alpha + float32(f32.DdotUnitary(a, b))' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1Sds\2_" \
      -e 's_^// D\(.*\)$_// Sds\1 plus a constant_' \
      -e 's_\\sum_alpha + \\sum_' \
      -e 's/n int/n int, alpha float32/' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> level1single_sdsdot.go


# Level2 routines.

echo Generating level2single.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level2single.go
cat level2double.go \
| gofmt -r 'blas.Float64Level2 -> blas.Float32Level2' \
\
| gofmt -r 'float64 -> float32' \
\
| gofmt -r 'Dscal -> Sscal' \
\
| gofmt -r 'f64.AxpyInc -> f32.AxpyInc' \
| gofmt -r 'f64.AxpyIncTo -> f32.AxpyIncTo' \
| gofmt -r 'f64.AxpyUnitary -> f32.AxpyUnitary' \
| gofmt -r 'f64.AxpyUnitaryTo -> f32.AxpyUnitaryTo' \
| gofmt -r 'f64.DotInc -> f32.DotInc' \
| gofmt -r 'f64.DotUnitary -> f32.DotUnitary' \
| gofmt -r 'f64.Ger -> f32.Ger' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1S\2_" \
      -e 's_^// D_// S_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> level2single.go


# Level3 routines.

echo Generating level3single.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > level3single.go
cat level3double.go \
| gofmt -r 'blas.Float64Level3 -> blas.Float32Level3' \
\
| gofmt -r 'float64 -> float32' \
\
| gofmt -r 'f64.AxpyUnitaryTo -> f32.AxpyUnitaryTo' \
| gofmt -r 'f64.DotUnitary -> f32.DotUnitary' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1S\2_" \
      -e 's_^// D_// S_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> level3single.go

echo Generating sgemm.go
echo -e '// Code generated by "go generate gonum.org/v1/gonum/blas/gonum”; DO NOT EDIT.\n' > sgemm.go
cat dgemm.go \
| gofmt -r 'float64 -> float32' \
| gofmt -r 'sliceView64 -> sliceView32' \
| gofmt -r 'checkDMatrix -> checkSMatrix' \
\
| gofmt -r 'dgemmParallel -> sgemmParallel' \
| gofmt -r 'computeNumBlocks64 -> computeNumBlocks32' \
| gofmt -r 'dgemmSerial -> sgemmSerial' \
| gofmt -r 'dgemmSerialNotNot -> sgemmSerialNotNot' \
| gofmt -r 'dgemmSerialTransNot -> sgemmSerialTransNot' \
| gofmt -r 'dgemmSerialNotTrans -> sgemmSerialNotTrans' \
| gofmt -r 'dgemmSerialTransTrans -> sgemmSerialTransTrans' \
\
| gofmt -r 'f64.AxpyInc -> f32.AxpyInc' \
| gofmt -r 'f64.AxpyIncTo -> f32.AxpyIncTo' \
| gofmt -r 'f64.AxpyUnitaryTo -> f32.AxpyUnitaryTo' \
| gofmt -r 'f64.DotUnitary -> f32.DotUnitary' \
\
| sed -e "s_^\(func (Implementation) \)D\(.*\)\$_$WARNING\1S\2_" \
      -e 's_^// D_// S_' \
      -e 's_^// d_// s_' \
      -e 's_"gonum.org/v1/gonum/internal/asm/f64"_"gonum.org/v1/gonum/internal/asm/f32"_' \
>> sgemm.go
