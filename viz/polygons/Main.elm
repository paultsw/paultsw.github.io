import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Time
import Time exposing (Time, second)
import Mouse

main : Element
main =
    collage 1000 800
        [ ngon 5 120.0
            |> filled (rgba 0 72 186 0.6)
            |> move (350.0, 200.0)
        , ngon 4 100.0
            |> filled (rgba 227 66 52 0.6)
            |> move (-100.0, -200.0)
        , ngon 3 220.0
            |> filled (rgba 68 215 168 0.6)
            |> move (-10.0, 5.0)
        , ngon 7 140.0
            |> filled (rgba 49 120 115 0.6)
            |> move (-200.0, 200.0)
        ]

{-
main : Element
main =
    collage 500 500
        [ generatePolygon
        , generatePolygon
        , generatePolygon
        , generatePolygon
        ]
-}
{-
generate a polygon with:
* a random (3-10) number of sides;
* a random color;
* a random angle of rotation;
* a random displacement
-}
generatePolygon : Form
generatePolygon =
    ngon nSides diameter
        |> filled generateColor
        |> move generateDisp

{-
Helper functions:
-}
generateColor : Color
generateColor =
    let
        colors = [ (0,72,186,0.6) -- absolute zero
                 , (0,127,255,0.6) -- azure
                 , (163,193,173,0.6) -- cambridge blue
                 , (220,20,60,0.6) -- crimson
                 , (227,66,52,0.6) -- cinnabar
                 , (255,40,0,0.6) -- ferrari red
                 , (68,215,168,0.6) -- eucalyptus
                 , (169,186,167,0.6) -- laurel green
                 , (49,120,115,0.6) -- myrtle
                 ]
    in
        rgba 0 72 186 0.6 -- FIX THIS FUNCTION

nSides : Int
nSides = randomInteger (3,5)

diameter : Float
diameter = 100.0 * (randomFloat 11)

generateDisp : (Float,Float) -- check this type annotation
generateDisp =
    let
        (x_disp,y_disp) = ((randomFloat -1),(randomFloat 1))
    in
        (0.0+x_disp , 0.0+y_disp)

{-
Fake randomness based on time and mouse:
-}

randomInteger : (Int,Int) -> Int
randomInteger (n,m) =
    n + m --Mouse.position; FIX THIS

randomFloat : Int -> Float
randomFloat n =
    ((toFloat n) / 10.0) -- FIX THIS