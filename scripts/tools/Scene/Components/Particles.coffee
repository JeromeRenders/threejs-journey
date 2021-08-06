# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

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
            # color:           new THREE.Color("#ff99cc")
            transparent:     true
            map: @options.loaders.texture.load("./scripts/tools/Scene/textures/particles/2.png")
            depthWrite: false
            vertexColors: true
        })
        @material.color.setHSL(1.0, 0.4, 0.7)

        @mesh = new THREE.Points(@geometry, @material)
        @options.scene.add @mesh

        @debug()

    debug: ->
        folder = @options.debug.addFolder({ title: "Particles", expanded: true })

    onUpdate: (elapsedTime) ->

        for i in [0...@count]
            i3 = i * 3
            x = @geometry.attributes.position.array[i3 + 0]
            @geometry.attributes.position.array[i3 + 1] = Math.sin(elapsedTime + x)

        @geometry.attributes.position.needsUpdate = true