[Mesh]
  file = flux_test.e
[]

[Variables/T]
  initial_condition = 200
[]

[Kernels]
  [diff]
    type = Diffusion
    variable = T
  []
  [body]
    type = BodyForce
    variable = T
    block = 2
    value = 10
  []
[]

[BCs]
  [fix_bc]
    type = DirichletBC
    variable = T
    boundary = 5
    value = 100
  []
[]

[Postprocessors]
inactive = 'block_1_top block_2_down'
  [block_2_right]
    type = InterfaceDiffusiveFluxIntegral
    variable = T
    boundary = 1
    diffusivity = 1
  []

  [block_1_left]
    type = InterfaceDiffusiveFluxIntegral
    variable = T
    boundary = '2'
    diffusivity = 1
  []

  [block_1_right]
    type = SideDiffusiveFluxIntegral
    variable = T
    boundary = '5'
    diffusivity = 1
  []
  [block_1_left_left]
    type = SideDiffusiveFluxIntegral
    variable = T
    boundary = '7 8'
    diffusivity = 1
  []
  [block_1_top]
    type = SideDiffusiveFluxIntegral
    variable = T
    boundary = 3
    diffusivity = 1
  []

  [block_2_down]
    type = SideDiffusiveFluxIntegral
    variable = T
    boundary = 4
    diffusivity = 1
  []
[]

[ThermalContact]
active = 'thermalcontact_left_right'
  [thermalcontact_up_down]
    type = GapHeatTransfer
    variable = T
    primary = 4
    secondary= 3
    gap_conductivity = 0.5
    quadrature = true
    emissivity_primary = 0.5
    emissivity_secondary = 0.5
  []
  [thermalcontact_left_right]
    type = GapHeatTransfer
    variable = T
    primary = 2
    secondary= 1
    gap_conductivity = 1
    quadrature = true
    emissivity_primary = 0.0
    emissivity_secondary = 0.0
  []
[]

[Executioner]
  type = Transient

  dt = 0.1
  num_steps = 10

  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-12
[]

[Outputs]
  exodus = true
[]

