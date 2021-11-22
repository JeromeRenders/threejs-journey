# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

import vertex   from "../shaders/shaders/vertex.vert"
import fragment from "../shaders/shaders/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        @config = {
            frequencyX: 10
            frequencyY: 5
        }

        if @options.debug then @debug()


    # ==================================================
    # > INIT
    # ==================================================
    init: ->

        @updateCameraPosition({ x: 0, y: 0, z: 2 })

        @geometry = new THREE.PlaneBufferGeometry(1, 1, 32, 32)
        @material = new THREE.ShaderMaterial(
            uniforms: {
                uFrequency: { value: new THREE.Vector2(@config.frequencyX, @config.frequencyY) }
                uTime:      { value: 0 }
                uColor:     { value: new THREE.Color("#888888") }
                uTexture:   { value: @options.loaders.texture.load("./scripts/tools/Scene/textures/flag-french.jpg") }
            }
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        @mesh = new THREE.Mesh(@geometry, @material)
        @mesh.scale.y = 2 / 3
        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "7. Shaders", expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "frequencyX", { min: 0, max: 20, step: 0.01 }).on("change", (val) =>
            @mesh.material.uniforms.uFrequency.value.x = @config.frequencyX
        )
        @debugFolder.addInput(@config, "frequencyY", { min: 0, max: 20, step: 0.01 }).on("change", (val) =>
            @mesh.material.uniforms.uFrequency.value.y = @config.frequencyY
        )


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        
        unless @mesh then return
        
        @mesh.material.uniforms.uTime.value += 0.01