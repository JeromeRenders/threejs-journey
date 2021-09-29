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

        geometry = new THREE.PlaneBufferGeometry(1, 1, 32, 32)
        material = new THREE.ShaderMaterial(
            uniforms: {
                uFrequency: { value: new THREE.Vector2(10, 5) }
                uTime:      { value: 0 }
                uColor:     { value: new THREE.Color("#888888") }
                uTexture:   { value: @options.loaders.texture.load("./scripts/tools/Scene/textures/flag-french.jpg") }
            }
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        # count = geometry.attributes.position.count
        # randoms = new Float32Array(count)
        # for i in [0...count] then randoms[i] = Math.random()
        # geometry.setAttribute("aRandom", new THREE.BufferAttribute(randoms, 1))


        @mesh = new THREE.Mesh(geometry, material)
        @mesh.scale.y = 2 / 3
        @options.scene.add(@mesh)

        if @options.debug then @debug()

        # 1:35:00

        # console.log @



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "Shaders", expanded: true })

        @debugFolder.addInput(@mesh.material.uniforms.uFrequency.value, "x", { min: 0, max: 20, step: 0.01, label: "frequencyX" })
        @debugFolder.addInput(@mesh.material.uniforms.uFrequency.value, "y", { min: 0, max: 20, step: 0.01, label: "frequencyY" })



    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        @mesh.material.uniforms.uTime.value = elapsedTime