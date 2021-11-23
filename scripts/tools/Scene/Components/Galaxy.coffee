# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

import vertex   from "../shaders/galaxy/vertex.vert"
import fragment from "../shaders/galaxy/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @title = "4. Galaxy 👀"

        @config = {
            count: 358800
            radius: 11.09
            branches: 10
            randomness: 0.848
            randomnessPower: 2.859
            insideColor: "#ff6030"
            outsideColor: "#1b3984"
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 5, y: 5, z: 5 })

        @geometry = null
        @material = null
        @points   = null

        @generate()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: @title, expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "count", { min: 100, max: 1000000, step: 100 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "radius", { min: .01, max: 20, step: .01 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "branches", { min: 2, max: 20, step: 1 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "randomness", { min: 0, max: 2, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "randomnessPower", { min: 1, max: 20, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "insideColor").on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "outsideColor").on("change", (e) => if e.last then @generate())


    # ==================================================
    # > UTILS
    # ==================================================
    destroy: ->
        if @geometry then @geometry.dispose()
        if @material then @material.dispose()
        @options.scene.remove(@points)

    generate: ->
        if @points != null then @destroy()

        @geometry = new THREE.BufferGeometry()

        positions  = new Float32Array(@config.count * 3)
        colors     = new Float32Array(@config.count * 3)
        scales     = new Float32Array(@config.count * 1)
        randomness = new Float32Array(@config.count * 3)

        colorInside  = new THREE.Color(@config.insideColor)
        colorOutside = new THREE.Color(@config.outsideColor)

        for i in [0...@config.count]
            i3 = i * 3

            # Position
            radius      = Math.random() * @config.radius
            branchAngle = (i % @config.branches) / @config.branches * Math.PI * 2

            positions[i3    ] = Math.cos(branchAngle) * radius
            positions[i3 + 1] = 0
            positions[i3 + 2] = Math.sin(branchAngle) * radius

            # Randomness
            randomness[i3    ] = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)
            randomness[i3 + 1] = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)
            randomness[i3 + 2] = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)

            # Color
            mixedColor = colorInside.clone()
            mixedColor.lerp(colorOutside, radius / @config.radius)

            colors[i3    ] = mixedColor.r
            colors[i3 + 1] = mixedColor.g
            colors[i3 + 2] = mixedColor.b

            # Scale
            scales[i] = Math.random()

        @geometry.addAttribute("position", new THREE.BufferAttribute(positions, 3))
        @geometry.addAttribute("color", new THREE.BufferAttribute(colors, 3))
        @geometry.addAttribute("aScale", new THREE.BufferAttribute(scales, 1))
        @geometry.addAttribute("aRandomness", new THREE.BufferAttribute(randomness, 3))

        @material = new THREE.ShaderMaterial({
            uniforms: {
                uTime: { value: 0 }
                uSize: { value: 30 * @options.renderer.getPixelRatio() }
            }
            vertexShader:   vertex
            fragmentShader: fragment
            vertexColors:   true
            depthWrite:     false
            blending:       THREE.AdditiveBlending
        })

        @points = new THREE.Points(@geometry, @material)
        @options.scene.add(@points)


    # ==================================================
    # > LOAD / UNLOAD
    # ==================================================
    unload: ->
        @destroy()


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        unless @material then return

        @material.uniforms.uTime.value = elapsedTime
