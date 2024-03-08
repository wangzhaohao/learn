# sampler for parameterizing multiple experiments
[StochasticTools]
[]

[Samplers]
  [omega_sampler]
    type = InputMatrix
    #omega;
    matrix = '2; 3; 5'
    execute_on = 'PRE_MULTIAPP_SETUP'
  []
[]

[MultiApps]
  [forward]
    type = SamplerFullSolveMultiApp
    input_files = forward.i
    sampler = omega_sampler
    ignore_solve_not_converge = true
    mode = normal #This is the only mode that works.  batch-reset will only transfer data to first sample
  []
[]

[Controls]
  [cmdLine]
    type = MultiAppSamplerControl
    multi_app = forward
    sampler = omega_sampler
    param_names = 'omega'
  []
[]

##---------------------------------------
# Getting objectives and gradients from each sample and combining
[Transfers]
  [fromForward]
    type = SamplerReporterTransfer
    from_multi_app = forward
    sampler = omega_sampler
    stochastic_reporter = storage
    from_reporter = 'obj_pp/value grad_f/grad_f'
  []
[]
[Reporters]
  [storage]
    type = StochasticReporter
    execute_on = 'initial timestep_end'
    parallel_type = ROOT
  []
  [grad_sum]
    type = ParsedVectorVectorRealReductionReporter
    name = row_sum
    reporter_name = "storage/fromForward:grad_f:grad_f"
    initial_value = 0
    expression = 'reduction_value+indexed_value'
  []
  [obj_sum]
    type = ParsedVectorRealReductionReporter
    name = value
    reporter_name = "storage/fromForward:obj_pp:value"
    initial_value = 0
    expression = 'reduction_value+indexed_value'
  []
[]

##---------------------------------------
#this is for getting controllable parameters down to the forward problem
[Reporters]
  [controllable_params]
    type = ConstantReporter
    real_vector_names = 'vals'
    real_vector_values = '0 4'
  []
[]

[Transfers]
  # regular transfer of the same controllable parameters to all subapps
  [toForward]
    type = MultiAppReporterTransfer
    to_multi_app = forward
    from_reporters = 'controllable_params/vals'
    to_reporters = 'vals/vals'
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

##---------------------------------------

[Outputs]
  console = false
[]
