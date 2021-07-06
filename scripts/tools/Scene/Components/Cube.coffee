# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->

        @config = {
            alpha:            "./build/img/cube/alpha.jpg"
            ambientOcclusion: "./build/img/cube/ambientOcclusion.jpg"
            color:            "./build/img/cube/color.jpg"
            height:           "./build/img/cube/height.jpg"
            metalness:        "./build/img/cube/metalness.jpg"
            normal:           "./build/img/cube/normal.jpg"
            roughness:        "./build/img/cube/roughness.jpg"
        }

        loadingManager = new THREE.LoadingManager()

        loadingManager.onStart = =>
            console.log "onStart"

        loadingManager.onLoad = =>
            console.log "onLoad"
            
        loadingManager.onProgress = =>
            console.log "onProgress"
            
        loadingManager.onError = =>
            console.log "onError"

        textureLoader = new THREE.TextureLoader(loadingManager)

        alphaTexture = textureLoader.load(@config.alpha)
        ambiantOcclusionTexture = textureLoader.load(@config.ambientOcclusion)
        colorTexture = textureLoader.load(@config.color)
        heightTexture = textureLoader.load(@config.height)
        metalnessTexture = textureLoader.load(@config.metalness)
        roughnessTexture = textureLoader.load(@config.roughness)

        @geometry = new THREE.BoxGeometry( 4, 4, 4 )
        @material = new THREE.MeshBasicMaterial({ map: colorTexture })
        @mesh    = new THREE.Mesh( @geometry, @material )


        @options.scene.add @mesh

    
    # onUpdate: (elapsedTime) ->
    #     @mesh.rotation.x = elapsedTime * .4
    #     @mesh.rotation.y = elapsedTime * .4
