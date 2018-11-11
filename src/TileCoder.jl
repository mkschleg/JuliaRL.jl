module TileCoder


mutable struct IHT
    size
    overfullCount
    dictionary
    IHT(sizeval) = new(sizeval, 0, Dict())
end

capacity(iht::IHT) = iht.size
count(iht::IHT) = length(iht.dictionary)
fullp(iht::IHT) = length(iht.dictionary) >= count(iht)

function getindex!(iht::IHT, obj, readonly=false)
    d = iht.dictionary
    if obj in keys(d)
        return d[obj]
    elseif readonly
        return None
    end
    iht_size = capacity(iht)
    iht_count = count(iht)
    if count(iht) >= capacity(iht)
        if iht.overfullCount==0
            println("IHT full, starting to allow collisions")
        end
        iht.overfullCount += 1
        return hash(obj) % capacity(iht)
    end
    d[obj] = iht_count
    return iht_count
end

hashcoords!(coordinates, m, readonly=false) = nothing
hashcoords!(coordinates, m::IHT, readonly=false) = getindex!(m, coordinates, readonly)
hashcoords!(coordinates, m::Integer, readonly=false) = hash(tuple(coordinates)) % m

function tiles!(ihtORsize, numtilings, floats, ints=[], readonly=false)
    qfloats = [floor(f*numtilings) for f in floats]
    tiles = zeros(Int64, numtilings)
    for tiling = 1:numtilings
        tilingX2 = tiling*2
        coords = convert(Array{Any}, [tiling])
        b = tiling
        for (q_idx, q) in enumerate(qfloats)
            append!(coords, floor((q + b) / numtilings))
            b += tilingX2
        end
        append!(coords, ints)
        tiles[tiling] = hashcoords!(coords, ihtORsize, readonly)
    end
    return tiles
end

function tileswrap!(ihtORsize, numtilings, floats, wrapwidths, ints=[], readonly=false)
    qfloats = [floor(f*numtilings) for f in floats]
    tiles = zeros(Int64, numtilings)
    for tiling = 1:numtilings
        tilingX2 = tiling*2
        coords = convert(Array{Any}, [tiling])
        b = tiling
        for (q_idx, q) in enumerate(qfloats)
            width = nothing
            if length(wrapwidths) >= q_idx
                width = wrapwidths[q_idx]
            end
            c = floor((q + b%numtilings) / numtilings)
            append!(coords, width==nothing ? c : c%width)
            b += tilingX2
        end
        append!(coords, ints)
        tiles[tiling] = hashcoords!(coords, ihtORsize, readonly)
    end
    return tiles
end

end
