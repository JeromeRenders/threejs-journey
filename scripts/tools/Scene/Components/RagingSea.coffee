# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

import vertex   from "../shaders/raging-sea/vertex.vert"
import fragment from "../shaders/raging-sea/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @config = {
            default: {
                smallWaves: {
                    speed: 0.978
                    elevation: 0.087
                    frequency: 7.5
                    iterations: 4
                }
                bigWaves: {
                    speed: 1.304
                    elevation: 0.098
                    frequency: { x: 2.609, y: 3.587 }
                    color: {
                        offset: 0.076
                        multiplier: 2.5
                        surface: "#84f8b1"
                        depth: "#04216c"
                    }
                }
            },
            blue: {
                smallWaves: {
                    speed: 0.978
                    elevation: 0.087
                    frequency: 7.5
                    iterations: 4
                }
                bigWaves: {
                    speed: 1.304
                    elevation: 0.098
                    frequency: { x: 2.609, y: 3.587 }
                    color: {
                        offset: 0.076
                        multiplier: 2.5
                        surface: "#84f8b1"
                        depth: "#04216c"
                    }
                }
            },
            lava: {
                smallWaves: {
                    speed: 0.435
                    elevation: 0.261
                    frequency: 1.630
                    iterations: 2
                }
                bigWaves: {
                    speed: 0.163
                    elevation: 0.163
                    frequency: { x: 2.609, y: 3.587 }
                    color: {
                        offset: 0.174 
                        multiplier: 2.935
                        surface: "#e8ce37"
                        depth: "#a53511"
                    }
                } 
            },
            greenSlug: {
                smallWaves: {
                    speed: 1.467
                    elevation: 0.065
                    frequency: 8.804
                    iterations: 1
                }
                bigWaves: {
                    speed: 1.304
                    elevation: 0.043
                    frequency: { x: 7.717, y: 4.457 }
                    color: {
                        offset: 0.120
                        multiplier: 3.696
                        surface: "#0fe864"
                        depth: "#425c5c"
                    }
                } 
            },
            movingSand: {
                smallWaves: {
                    speed: 0.543
                    elevation: 0.054
                    frequency: 5.978
                    iterations: 2
                }
                bigWaves: {
                    speed: 1.359
                    elevation: 0.022
                    frequency: { x: 3.370, y: 5.217 }
                    color: {
                        offset: 0
                        multiplier: 8.587
                        surface: "#f4ff3c"
                        depth: "#b87713"
                    }
                } 
            }
        }

        @init()

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 1.6, y: 1.3, z: 1.6 })

        @geometry = new THREE.PlaneBufferGeometry(2, 2, 128, 128)
        @material = new THREE.ShaderMaterial(
            uniforms: {
                uTime:                    { value: 0 }

                uSmallWavesSpeed:         { value: @config.default.smallWaves.speed }
                uSmallWavesElevation:     { value: @config.default.smallWaves.elevation }
                uSmallWavesFrequency:     { value: @config.default.smallWaves.frequency }
                uSmallWavesIterations:    { value: @config.default.smallWaves.iterations }

                uBigWavesElevation:       { value: @config.default.bigWaves.elevation }
                uBigWavesFrequency:       { value: new THREE.Vector2(@config.default.bigWaves.frequency.x, @config.default.bigWaves.frequency.y) }
                uBigWavesSpeed:           { value: @config.default.bigWaves.speed }
                uBigWavesColorOffset:     { value: @config.default.bigWaves.color.offset }
                uBigWavesColorMultiplier: { value: @config.default.bigWaves.color.multiplier }
                uBigWavesColorSurface:    { value: new THREE.Color(@config.default.bigWaves.color.surface) }
                uBigWavesColorDepth:      { value: new THREE.Color(@config.default.bigWaves.color.depth) }
            }
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        @mesh = new THREE.Mesh(@geometry, @material)
        @mesh.rotation.x = - Math.PI * 0.5

        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "9. Raging sea", expanded: true })
        
        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        smallWaves = @debugFolder.addFolder({ title: "Small waves", expanded: false })
        smallWaves.addInput(@config.default.smallWaves, "speed", { min: 0, max: 5, step: 0.001, label: "speed" }).on("change", (e) =>
            if @material then @material.uniforms.uSmallWavesSpeed.value = @config.default.smallWaves.speed
        )
        smallWaves.addInput(@config.default.smallWaves, "elevation", { min: 0, max: 1, step: 0.001, label: "elevation" }).on("change", (e) =>
            if @material then @material.uniforms.uSmallWavesElevation.value = @config.default.smallWaves.elevation
        )
        smallWaves.addInput(@config.default.smallWaves, "frequency", { min: 0, max: 10, step: 0.001, label: "frequency" }).on("change", (e) =>
            if @material then @material.uniforms.uSmallWavesFrequency.value = @config.default.smallWaves.frequency
        )
        smallWaves.addInput(@config.default.smallWaves, "iterations", { min: 1, max: 5, step: 1, label: "iterations" }).on("change", (e) =>
            if @material then @material.uniforms.uSmallWavesIterations.value = @config.default.smallWaves.iterations
        )

        bigWaves = @debugFolder.addFolder({ title: "Big waves", expanded: false })
        bigWaves.addInput(@config.default.bigWaves, "speed", { min: 0, max: 5, step: 0.001, label: "speed" }).on("change", (e) =>
            if @material then @material.uniforms.uBigWavesSpeed.value = @config.default.bigWaves.speed
        )
        bigWaves.addInput(@config.default.bigWaves, "elevation", { min: 0, max: 1, step: 0.001, label: "elevation" }).on("change", (e) =>
            if @material then @material.uniforms.uBigWavesElevation.value = @config.default.bigWaves.elevation
        )
        bigWaves.addInput(@config.default.bigWaves.frequency, "x", { min: 0, max: 10, step: 0.001, label: "frequencyX" }).on("change", (e) =>
            if @material then @material.uniforms.uBigWavesFrequency.value.x = @config.default.bigWaves.frequency.x
        )
        bigWaves.addInput(@config.default.bigWaves.frequency, "y", { min: 0, max: 10, step: 0.001, label: "frequencyY" }).on("change", (e) =>
            if @material then @material.uniforms.uBigWavesFrequency.value.y = @config.default.bigWaves.frequency.y
        )
        bigWaves.addInput(@config.default.bigWaves.color, "offset", { min: 0, max: 1, step: 0.001, label: "colorOffset" }).on("change", (val) =>
            if @material then @material.uniforms.uBigWavesColorOffset.value = @config.default.bigWaves.color.offset
        )
        bigWaves.addInput(@config.default.bigWaves.color, "multiplier", { min: 0, max: 10, step: 0.001, label: "colorMultiplier" }).on("change", (val) =>
            if @material then @material.uniforms.uBigWavesColorMultiplier.value = @config.default.bigWaves.color.multiplier
        )
        bigWaves.addInput(@config.default.bigWaves.color, "surface", { label: "colorSurface" }).on("change", (val) =>
            if @material then @material.uniforms.uBigWavesColorSurface.value = new THREE.Color(@config.default.bigWaves.color.surface)
        )
        bigWaves.addInput(@config.default.bigWaves.color, "depth", { label: "colorDepth" }).on("change", (val) =>
            if @material then @material.uniforms.uBigWavesColorDepth.value = new THREE.Color(@config.default.bigWaves.color.depth)
        )

        examples = @debugFolder.addFolder({ title: "Examples", expanded: false })
        examples.addButton({ title: "Default" }).on("click", =>
            if @material then @changeParams(@config.blue)
        )
        examples.addButton({ title: "Lava" }).on("click", =>
            if @material then @changeParams(@config.lava)
        )
        examples.addButton({ title: "Green slug" }).on("click", =>
            if @material then @changeParams(@config.greenSlug)
        )
        examples.addButton({ title: "Moving sand" }).on("click", =>
            if @material then @changeParams(@config.movingSand)
        )


    # ==================================================
    # > UTILS
    # ==================================================
    changeParams: (params) ->

        # Update material uniforms
        @material.uniforms.uSmallWavesSpeed.value         = params.smallWaves.speed
        @material.uniforms.uSmallWavesElevation.value     = params.smallWaves.elevation
        @material.uniforms.uSmallWavesFrequency.value     = params.smallWaves.frequency
        @material.uniforms.uSmallWavesIterations.value    = params.smallWaves.iterations
        @material.uniforms.uBigWavesSpeed.value           = params.bigWaves.speed
        @material.uniforms.uBigWavesElevation.value       = params.bigWaves.elevation
        @material.uniforms.uBigWavesFrequency.value.x     = params.bigWaves.frequency.x
        @material.uniforms.uBigWavesFrequency.value.y     = params.bigWaves.frequency.y
        @material.uniforms.uBigWavesColorOffset.value     = params.bigWaves.color.offset
        @material.uniforms.uBigWavesColorMultiplier.value = params.bigWaves.color.multiplier
        @material.uniforms.uBigWavesColorSurface.value    = new THREE.Color(params.bigWaves.color.surface)
        @material.uniforms.uBigWavesColorDepth.value      = new THREE.Color(params.bigWaves.color.depth)

        # Update the config array
        @config.default.smallWaves.speed = params.smallWaves.speed
        @config.default.smallWaves.elevation = params.smallWaves.elevation
        @config.default.smallWaves.frequency = params.smallWaves.frequency
        @config.default.smallWaves.iterations = params.smallWaves.iterations
        @config.default.bigWaves.speed = params.bigWaves.speed
        @config.default.bigWaves.elevation = params.bigWaves.elevation
        @config.default.bigWaves.frequency.x = params.bigWaves.frequency.x
        @config.default.bigWaves.frequency.y = params.bigWaves.frequency.y
        @config.default.bigWaves.color.offset = params.bigWaves.color.offset
        @config.default.bigWaves.color.multiplier = params.bigWaves.color.multiplier
        @config.default.bigWaves.color.surface = params.bigWaves.color.surface
        @config.default.bigWaves.color.depth = params.bigWaves.color.depth

        # Update the debug
        @options.debug.refresh()


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        
        unless @mesh then return

        @mesh.material.uniforms.uTime.value = elapsedTime