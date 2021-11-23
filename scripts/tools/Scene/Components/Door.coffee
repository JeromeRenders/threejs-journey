# =============================================================================
# > SCENE - COMPONENTS: DOOR TEXTURE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        super()

        light = new THREE.AmbientLight(0xffffff)
        @options.scene.add(light)

        alphaTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/alpha.jpg")
        ambientOcclusionTexture = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/ambientOcclusion.jpg")
        colorTexture            = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/color.jpg")
        heightTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/height.jpg")
        metalnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/metalness.jpg")
        normalTexture           = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/normal.jpg")
        roughnessTexture        = @options.loaders.texture.load("./scripts/tools/Scene/textures/door/roughness.jpg")

        @geometry = new THREE.PlaneBufferGeometry(4, 4, 100, 100)
        @geometry.addAttribute("uv2", new THREE.BufferAttribute(@geometry.attributes.uv.array, 2))

        @material = new THREE.MeshStandardMaterial()
        @material.map = colorTexture
        @material.aoMap = ambientOcclusionTexture
        @material.aoMapIntensity = 1.09
        @material.displacementMap = heightTexture
        @material.displacementScale = 0.05
        @material.metalnessMap = metalnessTexture
        @material.roughnessMap = roughnessTexture
        @material.normalMap = normalTexture
        @material.alphaMap = alphaTexture
        @material.transparent = true

        @mesh     = new THREE.Mesh( @geometry, @material )

        @options.scene.add @mesh

        console.log @mesh

        if @options.debug then @debug()


    debug: ->
        folder = @options.debug.addFolder({ title: "Door", expanded: true })

        folder.addInput(@material, "metalness", { min: 0, max: 1, step: .01 })
        folder.addInput(@material, "roughness", { min: 0, max: 1, step: .01 })
        folder.addInput(@material, "aoMapIntensity", { min: 0, max: 10, step: .01 })
        folder.addInput(@material, "displacementScale", { min: 0, max: 1, step: .01 })


    # onUpdate: (elapsedTime) ->
    #     @mesh.rotation.x = elapsedTime * .4
    #     @mesh.rotation.y = elapsedTime * .4
