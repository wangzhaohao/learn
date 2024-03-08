#
# Internal Volume Test
#
# This test is designed to compute the internal volume of a cone.
#
# The mesh is composed of one block (1).  The height is 3/pi, and the radius
#   is 1.  Thus, the volume is 1/3*pi*r^2*h = 1.
#

[GlobalParams]
  displacements = 'disp_x disp_y'
  coord_type = RZ
[]

[Mesh]
  file = meshes/rz_cone.e
[]

[Functions]
  [./pressure]
    type = PiecewiseLinear
    x = '0. 1.'
    y = '0. 1.'
    scale_factor = 1e6
  [../]
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Modules/TensorMechanics/Master]
  [./all]
    volumetric_locking_correction = true
    incremental = true
    strain = FINITE
  [../]
[]

[BCs]
  # 固定1边界，为啥还要在施加压力边界，这样子压力边界不会起作用，导致体积不发生变化，如果去掉某一个方向位移的限制，则会产生变形，最后会发现internalVolume发生变化
  inactive = 'no_x'
  [./no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 1
    value = 0.0
  [../]

  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 1
    value = 0.0
  [../]

  [./Pressure]
    [./fred]
      boundary = 1
      function = pressure
    [../]
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e6
    poissons_ratio = 0.3
  [../]

  [./stress]
    type = ComputeFiniteStrainElasticStress
  [../]
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  nl_abs_tol = 1e-9

  start_time = 0.0
  dt = 1.0
  end_time = 1.0
[]

[Postprocessors]
  [./internalVolume]
    type = InternalVolume
    boundary = 1
    execute_on = 'initial timestep_end'
  [../]
[]

[Outputs]
  csv = true
  exodus = true
[]
