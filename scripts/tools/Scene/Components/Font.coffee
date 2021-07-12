# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"

 
export default class extends BaseComponent

    constructor: (@options) ->

        matcap = @options.loaders.texture.load("./scripts/tools/Scene/textures/matcaps/1.png")
        console.log matcap

        @options.loaders.font.load "./scripts/tools/Scene/fonts/helvetiker_regular.typeface.json", (font) =>
            @geometry = new THREE.TextBufferGeometry("Jerome", {
                font:           font
                size:           1.5
                height:         0.8
                curveSegments:  10
                bevelEnabled:   true
                bevelThickness: 0.03
                bevelSize:      0.02
                bevelOffset:    0
                bevelSegments:  8
            })
            @geometry.center()

            @material = new THREE.MeshMatcapMaterial({
                matcap: matcap
            })

            @mesh     = new THREE.Mesh( @geometry, @material )

            @options.scene.add @mesh
            @debug()

    
    debug: ->
        folder = @options.debug.addFolder({ title: "Font", expanded: true })

    #     folder.addInput(@material, "metalness", { min: 0, max: 1, step: .01 })
    #     folder.addInput(@material, "roughness", { min: 0, max: 1, step: .01 })
    #     folder.addInput(@material, "aoMapIntensity", { min: 0, max: 10, step: .01 })
    #     folder.addInput(@material, "displacementScale", { min: 0, max: 1, step: .01 })

    
    # onUpdate: (elapsedTime) ->
    #     @mesh.rotation.x = elapsedTime * .4
    #     @mesh.rotation.y = elapsedTime * .4
