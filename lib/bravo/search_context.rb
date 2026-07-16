# Evaluation context for resource search lambdas: exposes `query` (the
# policy-scoped relation) and `q` (the search term).
Bravo::SearchContext = Struct.new(:query, :q)
