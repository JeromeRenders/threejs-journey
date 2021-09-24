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
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        count = geometry.attributes.position.count
        randoms = new Float32Array(count)
        for i in [0...count] then randoms[i] = Math.random()
        geometry.setAttribute("aRandom", new THREE.BufferAttribute(randoms, 1))

        
        @mesh = new THREE.Mesh(geometry, material)
        @options.scene.add(@mesh)

        if @options.debug then @debug()

        # 1:35:00

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