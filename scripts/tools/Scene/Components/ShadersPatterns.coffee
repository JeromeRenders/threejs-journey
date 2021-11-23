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

        @config = {
            pattern: 0.2
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
                uTime:    { value: 0 }
                uPattern: { value: @config.pattern }
            }
            vertexShader: vertex
            fragmentShader: fragment
            wireframe: false
            side: THREE.DoubleSide
        )

        @mesh = new THREE.Mesh(@geometry, @material)
        @options.scene.add(@mesh)


    # ==================================================
    # > DEBUG
    # ==================================================
    debug: ->

        @debugFolder = @options.debug.addFolder({ title: "8. Shaders Patterns", expanded: false })

        @debugFolder.addButton({ title: "Load" }).on("click", (e) => @load() )
        @debugFolder.addButton({ title: "Unload" }).on("click", (e) => @unload() )
        @debugFolder.addSeparator()

        @debugFolder.addInput(@config, "pattern", {
            options: {
                checkboard: 0,
                stars:      0.1,
                noise:      0.2,
            }
        }).on("change", (val) =>
            @material.uniforms.uPattern.value = @config.pattern
        )


    # ==================================================
    # > EVENTS
    # ==================================================
    onUpdate: (elapsedTime) ->

        unless @mesh then return

        @mesh.material.uniforms.uTime.value += 0.01