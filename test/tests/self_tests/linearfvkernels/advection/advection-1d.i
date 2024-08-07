[Mesh]
  [gmg]
    type = GeneratedMeshGenerator
    dim = 1
    nx = 2
  []
[]

[Problem]
  linear_sys_names = 'u_sys'
[]

[Variables]
  [u]
    type = MooseLinearVariableFVReal
    solver_sys = 'u_sys'
    initial_condition = 1.0
  []
[]

[LinearFVKernels]
  [advection]
    type = LinearFVAdvection
    variable = u
    velocity = "0.5 0 0"
    advected_interp_method = upwind
  []
  [source]
    type = LinearFVSource
    variable = u
    source_density = source_func
  []
[]

[LinearFVBCs]
  [inflow]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    variable = u
    boundary = "left"
    functor = analytic_solution
  []
  [outflow]
    type = LinearFVAdvectionDiffusionOutflowBC
    variable = u
    boundary = "right"
    use_two_term_expansion = false
  []
[]

[Functions]
  [source_func]
    type = ParsedFunction
    expression = '0.5*x'
  []
  [analytic_solution]
    type = ParsedFunction
    expression = '0.5+0.5*x*x'
  []
[]

[Postprocessors]
  [error]
    type = ElementL2FunctorError
    approximate = u
    exact = analytic_solution
    execute_on = FINAL
  []
  [h]
    type = AverageElementSize
    execute_on = FINAL
  []
[]

[Executioner]
  type = LinearPicardSteady
  linear_systems_to_solve = u_sys
  number_of_iterations = 1
[]

[Outputs]
  [csv]
    type = CSV
    execute_on = FINAL
  []
[]
