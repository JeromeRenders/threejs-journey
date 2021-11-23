# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @title = "1. Font"

        @config = {
            matcap: 1
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 0, y: 0, z: 15 })

        matcap = @options.loaders.texture.load("./scripts/tools/Scene/textures/matcaps/1.png")

        @options.loaders.font.load "./scripts/tools/Scene/fonts/helvetiker_regular.typeface.json", (font) =>
            @geometry = new THREE.TextBufferGeometry("Hungry Minds RPZ", {
                font:           font
                size:           1.5
                height:         0.8
                curveSegments:  10
                bevelEnabled:   true
                bevelThickness: 0.03
                bevelSize:      0.02
                bevelOffset:    0
                bevelSegments:  8
            })
            @geometry.center()

            @material = new THREE.MeshMatcapMaterial({
                matcap: matcap
            })

            @mesh     = new THREE.Mesh( @geometry, @material )

            @options.scene.add @mesh



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "matcap", {
            options: {
                gold: 1,
                blue: 2,
                glass: 3,
                red_orange: 4,
                red: 5,
                skin: 6,
                green: 7,
                red_blue: 8
            }
        }).on("change", (val) =>
            if @material then @material.matcap = @options.loaders.texture.load("./scripts/tools/Scene/textures/matcaps/" + val.value + ".png")
        )

