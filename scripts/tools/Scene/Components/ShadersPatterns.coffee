# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

import vertex   from "../shaders/shaders-patterns/vertex.vert"
import fragment from "../shaders/shaders-patterns/fragment.frag"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        geometry = new THREE.PlaneBufferGeometry(1, 1, 32, 32)
        material = new THREE.ShaderMaterial(
            uniforms: {
                uTime:      { value: 0 }
            }
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        @mesh = new THREE.Mesh(geometry, material)
        @options.scene.add(@mesh)

        if @options.debug then @debug()

        # console.log @



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "Shaders Patterns", expanded: true })



    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->
        @mesh.material.uniforms.uTime.value = elapsedTime