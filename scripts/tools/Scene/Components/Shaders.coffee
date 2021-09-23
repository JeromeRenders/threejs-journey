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
        
        @mesh = new THREE.Mesh(
            new THREE.PlaneBufferGeometry(1, 1, 32, 32),
            new THREE.ShaderMaterial(
                uniforms: {

                }
                vertexShader: vertex
                fragmentShader: fragment
                wireframe: false
            )
        )
        @options.scene.add(@mesh)

        if @options.debug then @debug()

        # Start at 39:58

        # console.log @



    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        folder = @options.debug.addFolder({ title: "Shaders", expanded: true })




    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->