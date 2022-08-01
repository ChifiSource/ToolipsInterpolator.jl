<div align = "center"><img src = "https://github.com/ChifiSource/image_dump/blob/main/toolips/toolipsinterpolator.png" href = "https://toolips.app"></img></div>
</br>

The interpolator extension provides a single `Toolips.Servable`, the `InterpolatedFile`. This can be read from a directory, and is provided arguments to determine what to replace variable names with. Variable names are denoted with a `$`, much like in regular Julia.
- [Documentation](doc.toolips.app/extensions/toolips_interpolator)
- [Toolips](https://github.com/ChifiSource/Toolips.jl)
- [Extension Gallery](https://doc.toolips.app/?page=gallery&selected=interpolator)
##### index.html
```html
<h1>Toolips interpolator example</h1>
<p>$xis is the number</p>
<h3> This should be a p:</h3>
<div align="center">
$helloworld
</div>
$mybutt
$regdiv
$myval
```

##### MyApp.jl
```julia
module MyApp
using Toolips
using ToolipsInterpolator
# welcome to your new toolips project!
"""
home(c::Connection) -> _
--------------------
The home function is served as a route inside of your server by default. To
    change this, view the start method below.
"""
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

fourofour = route("404") do c
    write!(c, p("404message", text = "404, not found!"))
end

routes = [route("/", home), fourofour]
extensions = Vector{ServerExtension}([Logger(), ])
"""
start(IP::String, PORT::Integer, ) -> ::ToolipsServer
--------------------
The start function starts the WebServer.
"""
function start(IP::String = "127.0.0.1", PORT::Integer = 8000)
     ws = WebServer(IP, PORT, routes = routes, extensions = extensions)
     ws.start(); ws
end
end # - module

```
