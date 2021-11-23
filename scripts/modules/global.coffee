import gsap             from "gsap"

import SceneManager     from "../tools/Scene/SceneManager.coffee"

document.addEventListener("DOMContentLoaded", ->

    # ==================================================
    # > THREEJS SCENE
    # ==================================================
    scene = new SceneManager({
        container: document.querySelector("body")
        debug:     true
        controls:  false
        stats:     true
        composer:  false
    })

)