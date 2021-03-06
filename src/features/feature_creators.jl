export AbstractFeatureConstructor, create_features, feature_size

"""
    AbstractFeatureCreator
An abstract feature creator, for feature transformation from the states.
"""
abstract type AbstractFeatureConstructor end

"""
    create_features(fc::AbstractFeatureCreator, s)
Actually create the features
"""
function create_features(fc::AbstractFeatureConstructor, s; kwargs...)
    throw("Implement create features for $(typof(fc))")
end

"""
    feature_size(fc::AbstractFeatureCreator)
Get size of feature vector the features assume exists.
"""
function feature_size(fc::AbstractFeatureConstructor)
    throw("Implement feature size for $(typof(fc))")
end


# export TileCoder
# include("FeatureCreators/TileCoder.jl")

# export KenervaCoder
# include("FeatureCreators/KenervaCoder.jl")
