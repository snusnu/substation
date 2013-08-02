* Rename Chain#failure_chain to Chain#exception_chain
* Investigate and fix a bug when exceptions are raised within failure chains
* Introduce DSL::Data and DSL::Data::Mutable to simplify DSL implementations
* Guard against redefining methods already defined in Chain::DSL
* Enforce chains to be disjoint
