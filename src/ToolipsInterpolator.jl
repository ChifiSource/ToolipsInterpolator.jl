"""
Created in August, 2022 by
[chifi - an open source software dynasty.](https://github.com/orgs/ChifiSource)
by team
[toolips](https://github.com/orgs/ChifiSource/teams/toolips)
This software is MIT-licensed.
### ToolipsInterpolator
Toolips Interpolator provides the InterpolatedFile Servable, which can add
arguments and Components to files by name. For more info, see `InterpolatedFile`.
##### Module Composition
- [**ToolipsInterpolator**](https://github.com/ChifiSource/ToolipsInterpolator.jl)
"""

module ToolipsInterpolator
using Toolips
import Toolips: Servable, AbstractConnection, SpoofConnection, AbstractComponent

macro L_str(s::String)
    s
end

"""
### InterpolatedFile <: Servable
- dir::String
- f::Function
- components::Vector{Servable}
- args::Dict{String, String}\n
Creates an interpolated file, where `args` are values filled by their names in
HTML and components are filled by their names, as well. Use a dollar sign to
denote a variable, just as in Julia. Note that () cannot be used.
##### example
**HTML:**
```
<h1>Toolips interpolator example</h1>
<p>\$xis is the number</p>
<h3> This should be a p:</h3>
<div align="center">
\$helloworld
</div>
\$mybutt
\$regdiv
\$myval
```
**Julia:**
```
function home(c::Connection)
    newp = p("helloworld", text = "hello world!")
    myx = 5
    mybutt = button("mybutt", text = "my button!")
    regdiv = div("regdiv")
    myval = "what the heck"
    intfile = InterpolatedFile("src/index.html", xis = myx, myval = myval,
    regdiv, mybutt, newp)
    write!(c, intfile)
end
```
------------------
##### constructors
- InterpolatedFile(dir::String, components::Servable ..., args ...)
"""
mutable struct InterpolatedFile <: Servable
    dir::String
    f::Function
    components::Vector{Servable}
    args::Dict{String, String}
    function InterpolatedFile(dir::String, components::Servable ...; args ...)
        args::Dict{String, String} = Dict([string(arg[1]) => string(arg[2]) for arg in args])
        components::Vector{Servable} = Vector{Servable}([components ...])
        f(c::AbstractConnection) = begin
            rawfile::String = read(dir, String)
            [begin
                spf = SpoofConnection()
                write!(spf, comp)
                rawfile = replace(rawfile, "\$$(comp.name)" => spf.http.text)
            end for comp in components]
            [begin
            rawfile = replace(rawfile, "\$$(arg[1])" => arg[2])
        end for arg in args]
            write!(c, rawfile)
        end
        new(dir, f, components, args)::InterpolatedFile
    end
end
export InterpolatedFile
end # module
