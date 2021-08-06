# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        @config =
            count: 100000
            size: 0.01
            radius: 5
            branches: 3
            spin: 1
            randomness: 0.2
            randomnessPower: 3
            insideColor: "#ff6030"
            outsideColor: "#1b3984"

        @geometry = null
        @material = null
        @points   = null

        @generate()

        @debug()


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->
        folder = @options.debug.addFolder({ title: "Galaxy", expanded: true })

        folder.addInput(@config, "count", { min: 100, max: 1000000, step: 100 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "size", { min: .001, max: .1, step: .001 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "radius", { min: .01, max: 20, step: .01 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "branches", { min: 2, max: 20, step: 1 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "spin", { min: -5, max: 5, step: .001 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "randomness", { min: 0, max: 2, step: .001 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "randomnessPower", { min: 1, max: 20, step: .001 }).on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "insideColor").on("change", (e) => if e.last then @generate())
        folder.addInput(@config, "outsideColor").on("change", (e) => if e.last then @generate())


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
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
