module TOGZMQServer

using TOGZMQAPIServer
using TOGZMQAPIServer: push!
using TOGOctahedron: Octahedron
# using TOGInstall
using TOG: t
import TOG.∃!

function awaken(; router, pub, tog, ω)
    @show "TOGZMQServer.awaken", router, pub, tog
    push!(:time, time(ω))
    # push!(:awaken, awakengod(router, pub, tog))
    push!(:create, create(ω))
    push!(:observe, observe(ω))
    TOGZMQAPIServer.awaken(tog)
end

# awakengod(router, pub, tog) = name -> TOGInstall.awakengod(name=name, router=router, pub=pub, tog=tog)

time(ω) = _ -> t(ω)

create(ω) = x -> create(x..., ω)
function create(o::Octahedron, μ, ρ, ϕ, ∂₀, ∂₁, n, ω)
    length(μ == 2) && return ∃!2d(o, μ, ρ, ϕ, ∂₀, ∂₁, n, ω)
    length(μ == 3) && return ∃!3d(o, μ, ρ, ϕ, ∂₀, ∂₁, n, ω)
    length(μ == 4) && return ∃!4d(o, μ, ρ, ϕ, ∂₀, ∂₁, n, ω)
    ∃!(o, ϕ, ∂₀, ∂₁, n, ω)
end

observe(ω) = x -> observe(x..., ω)
observe(o::Octahedron, ω) = ∃̇(o, ω)

function ∃!(o::Octahedron, ϕ, ∂₀, ∂₁, n, ω=o.Ω)
    _, _, _, μ̃, ρ̃, _, _, _, _, _, _ = pyramid(o)
    ∃!(∃(o.d, μ̃, ρ̃, ∂₀, ∂₁, ϕ), n, ω)
end
function ∃!2d(o::Octahedron, μ, ρ, ϕ, ∂₀, ∂₁, n, ω=o.Ω)
    _, z, dx, dy, _, _, _, _, zo, _, _ = pyramid(o)
    μ̃ = z .+ 2 * (μ[1] * dx .+ μ[2] * dy)
    dx̃ = 2 * dx * ρ[1]
    dỹ = 2 * dy * ρ[2]
    dz̃ = typemin(T) / o.norm(zo) * zo
    μ̃, ρ̃ = box_aabb(μ̃, SA[dx̃, dỹ, dz̃])
    ∃!(∃(o.d, μ̃, ρ̃, ∂₀, ∂₁, ϕ), n, ω)
end
function ∃!3d(o::Octahedron, μ, ρ, ϕ, ∂₀, ∂₁, n, ω=o.Ω)
    _, z, dx, dy, _, _, za, _, _, _, _ = pyramid(o)
    t̃ = one(T) - μ[3]
    μ̃ = z .+ μ[3] * za .+ 2 * (μ[1] * t̃ * dx .+ μ[2] * t̃ * dy)
    ρ̃ = zeros(μ̃)
    ρ̃[2] = 2 * o.norm(dx) * ρ[1] * t̃ * min(μ[1], one(T) - μ[1])
    ρ̃[3] = 2 * o.norm(dy) * ρ[2] * t̃ * min(μ[2], one(T) - μ[2])
    ρ̃[4] = o.norm(za) * ρ[3] * min(μ[3], (one(T) - max(μ[1], μ[2])) * t̃)
    ∃!(∃(o.d, μ̃, ρ̃, ∂₀, ∂₁, ϕ), n, ω)
end
function ∃!4d(o::Octahedron, μ, ρ, ϕ, ∂₀, ∂₁, n, ω=o.Ω)
    # todo
end


# """
# Will show 2d Typst in TOG with center μ and radius ρ. Only needs actual content, page is already setup. 
# """
# put!(::Type{TOG}, typst_code::String, μ::SVector{2,T}=SA[○, ○], ρ::SVector{2,T}=SA[○, ○]) = ∃!2d(typst(typst_code), μ, ρ)
# """
# Will show 2d RGBA matrix in TOG with center μ and radius ρ.
# """
# put!(::Type{TOG}, mat::AbstractMatrix{PNGFiles.ColorTypes.RGBA}, μ::SVector{2,T}=SA[○, ○], ρ::SVector{2,T}=SA[○, ○]) = ∃!2d(rgbamatrix(mat), μ, ρ)
# """
# Will show a 2d ϕ:(t,x,y)->[0,1] in TOG with center μ and radius ρ.
# """
# put!(::Type{TOG}, ϕ::Function, μ::SVector{2,T}=SA[○, ○], ρ::SVector{2,T}=SA[○, ○]) = ∃!2d(ϕ, μ, ρ)
# # put!(::Type{TOG}, ϕ::Function, μ::SVector{2,T}=SA[○, ○], ρ::SVector{2,T}=SA[○, ○]) = ∃!2d(x -> ϕ((x[1], x[2], x[3])), μ, ρ)
# """Will travel to a random location in TOG essentially "clearing" the view."""
# function put!(::Type{TOG})
#     g = godBROWSER[].g
#     δg = g.ône.μ[end] - g.ẑero.μ[end]
#     μ̇1 = SA[g.ẑero.μ[1], rand(T, 3)...]
#     μ̇2 = SA[μ̇1[1], μ̇1[2], μ̇1[3], μ̇1[4]+δg]
#     while !valid(μ̇1, μ̇2, g.ρ, g.θ, g.norm)
#         yield()
#         μ̇1 = SA[g.ẑero.μ[1], rand(T, 3)...]
#         μ̇2 = SA[μ̇1[1], μ̇1[2], μ̇1[3], μ̇1[4]+δg]
#     end
#     move!(g, μ̇1)
#     focus!(g, μ̇2)
# end

end
