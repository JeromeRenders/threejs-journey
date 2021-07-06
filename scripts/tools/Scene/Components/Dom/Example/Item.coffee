# =============================================================================
# > SCENE - COMPONENTS: DODECAHEDRON
# =============================================================================

import * as THREE      from "three"
import gsap            from "gsap"

import DomItem         from "../DomItem.coffee"

import vertex          from "./shaders/vertex.vert"
import fragment        from "./shaders/fragment.frag"



# ==================================================
# > CLASS
# ==================================================
export default class extends DomItem


    # ==================================================
    # > RENDER
    # ==================================================
    beforeRender: ->

        @geometry = new THREE.PlaneBufferGeometry(1, 1, 1, 1)
        @material = new THREE.ShaderMaterial({
            transparent:    false
            vertexShader:   vertex
            fragmentShader: fragment
            uniforms: {
                uTime:     { type: "f", value: 0 }
                uProgress: { type: "f", value: @config.progress }
            }
        })
        @mesh = new THREE.Mesh(@geometry, @material)

        @options.scene.add(@mesh)


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: ->
        @material.uniforms.uTime.value += 0.05

    onMouseEnter: ->
        gsap.to(@material.uniforms.uProgress, {
            value: 1
            duration: 1
        })

    onMouseLeave: ->
        gsap.to(@material.uniforms.uProgress, {
            value: 0
            duration: 1
        })