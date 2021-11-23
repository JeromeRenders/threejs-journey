# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @title = "3. Particles"

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 0, y: 2, z: 5 })

        @geometry = new THREE.BufferGeometry()

        @count     = 5000
        positions = new Float32Array(@count * 3)
        colors    = new Float32Array(@count * 3)

        for i in [0...@count * 3]
            positions[i] = (Math.random() - .5) * 20
            colors[i] = Math.random()

        @geometry.addAttribute("position", new THREE.BufferAttribute(positions, 3))
        @geometry.addAttribute("color", new THREE.BufferAttribute(colors, 3))

        @material = new THREE.PointsMaterial({
            size:            0.2
            sizeAttenuation: true
            map: @options.loaders.texture.load("./scripts/tools/Scene/textures/particles/2.png")
            depthWrite: false
            vertexColors: true
            blending:       THREE.AdditiveBlending
        })
        @material.color.setHSL(1.0, 0.4, 0.7)

        @mesh = new THREE.Points(@geometry, @material)
        @options.scene.add @mesh


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        if @geometry

            for i in [0...@count]
                i3 = i * 3
                x = @geometry.attributes.position.array[i3 + 0]
                @geometry.attributes.position.array[i3 + 1] = Math.sin(elapsedTime + x)

            @geometry.attributes.position.needsUpdate = true