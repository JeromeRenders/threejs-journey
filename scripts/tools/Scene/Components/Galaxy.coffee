# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        super()

        @config = {
            count: 100000
            size: 0.01
            radius: 5
            branches: 9
            spin: 1
            randomness: 0.2
            randomnessPower: 3
            insideColor: "#ff6030"
            outsideColor: "#1b3984"
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 0, y: 10, z: 0 })

        @geometry = null
        @material = null
        @points   = null

        @generate()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        @debugFolder = @options.debug.addFolder({ title: "4. Galaxy", expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "count", { min: 100, max: 1000000, step: 100 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "size", { min: .001, max: .1, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "radius", { min: .01, max: 20, step: .01 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "branches", { min: 2, max: 20, step: 1 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "spin", { min: -5, max: 5, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "randomness", { min: 0, max: 2, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "randomnessPower", { min: 1, max: 20, step: .001 }).on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "insideColor").on("change", (e) => if e.last then @generate())
        @debugFolder.addInput(@config, "outsideColor").on("change", (e) => if e.last then @generate())


    # ==================================================
    # > UTILS
    # ==================================================
    destroy: ->
        @geometry.dispose()
        @material.dispose()
        @options.scene.remove(@points)

    generate: ->
        if @points != null then @destroy()

        @geometry = new THREE.BufferGeometry()
        positions = new Float32Array(@config.count * 3)
        colors    = new Float32Array(@config.count * 3)

        colorInside  = new THREE.Color(@config.insideColor)
        colorOutside = new THREE.Color(@config.outsideColor)

        for i in [0...@config.count]
            i3 = i * 3

            radius      = Math.random() * @config.radius
            spinAngle   = radius * @config.spin
            branchAngle = (i % @config.branches) / @config.branches * Math.PI * 2

            randomX = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)
            randomY = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)
            randomZ = Math.pow(Math.random(), @config.randomnessPower) * (if Math.random() < .5 then 1 else -1)

            positions[i3 + 0] = Math.cos(branchAngle + spinAngle) * radius + randomX
            positions[i3 + 1] = randomY
            positions[i3 + 2] = Math.sin(branchAngle + spinAngle) * radius + randomZ

            mixedColor = colorInside.clone()
            mixedColor.lerp(colorOutside, radius / @config.radius)

            colors[i3 + 0] = mixedColor.r
            colors[i3 + 1] = mixedColor.g
            colors[i3 + 2] = mixedColor.b

        @geometry.addAttribute("position", new THREE.BufferAttribute(positions, 3))
        @geometry.addAttribute("color", new THREE.BufferAttribute(colors, 3))

        @material = new THREE.PointsMaterial({
            size:            @config.size
            sizeAttenuation: true
            depthWrite:      false
            blending:        THREE.AdditiveBlending
            vertexColors:    true
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
