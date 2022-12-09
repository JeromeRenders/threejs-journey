import gsap             from "gsap"

import SceneManager     from "../tools/Scene/SceneManager.coffee"

document.addEventListener("DOMContentLoaded", ->

    # ==================================================
    # > THREEJS SCENE
    # ==================================================
    hash = window.location.hash
    scene = new SceneManager({
        container: document.querySelector("body")
        debug:     if hash.includes("debug") then true else false
        controls:  if hash.includes("debug") then true else false
        stats:     if hash.includes("debug") then true else false
        composer:  false
    })

)