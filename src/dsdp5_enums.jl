# Copyright (c) 2022: Joey Huchette, Benoît Legat, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# Automatically generated using Clang.jl wrap_c, version 0.0.0

const DSDPTruth = Cuint

# begin enum DSDPTerminationReason
const DSDPTerminationReason = Cint
const DSDP_CONVERGED = DSDPTerminationReason(1) # Good news: Solution found
const DSDP_INFEASIBLE_START = DSDPTerminationReason(-6) # The initial points y and r imply that S is not positive
const DSDP_SMALL_STEPS = DSDPTerminationReason(-2) # Short step lengths created by numerical difficulties prevent progress
const DSDP_INDEFINITE_SCHUR_MATRIX = DSDPTerminationReason(-8) # Theoretically this matrix is positive definite
const DSDP_MAX_IT = DSDPTerminationReason(-3) # Reached maximum number of iterations
const DSDP_NUMERICAL_ERROR = DSDPTerminationReason(-9) # Another numerical error occurred. Check solution
const DSDP_UPPERBOUND = DSDPTerminationReason(5) # Objective (DD) big enough to stop
const DSDP_USER_TERMINATION = DSDPTerminationReason(7) # DSDP didn't stop it, did you?
const CONTINUE_ITERATING = DSDPTerminationReason(0) # Don't Stop
# end enum DSDPTerminationReason

# begin enum DSDPSolutionType
const DSDPSolutionType = Cuint # converged
const DSDP_PDUNKNOWN = DSDPSolutionType(0) # Not sure whether (D) or (P) is feasible, check y bounds
const DSDP_PDFEASIBLE = DSDPSolutionType(1) # Both (D) and (P) are feasible and bounded
const DSDP_UNBOUNDED = DSDPSolutionType(3) # (D) is unbounded and (P) is infeasible
const DSDP_INFEASIBLE = DSDPSolutionType(4) # (D) in infeasible and (P) is unbounded
# end enum DSDPSolutionType

# begin enum DSDPDualFactorMatrix
const DSDPDualFactorMatrix = Cuint
const DUAL_FACTOR = DSDPDualFactorMatrix(1) # First instance for dual variable S
const PRIMAL_FACTOR = DSDPDualFactorMatrix(2) # Second instance used to compute X
# end enum DSDPDualFactorMatrix

# begin enum DSDPPenalty
const DSDPPenalty = Cuint
const DSDPAlways = DSDPPenalty(1)
const DSDPNever = DSDPPenalty(2)
const DSDPInfeasible = DSDPPenalty(0)
# end enum DSDPPenalty
