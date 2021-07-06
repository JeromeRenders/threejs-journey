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
            ambiantOcclusion: "./build/img/cube/ambiantOcclusion.jpg"
            color:            "./build/img/cube/color.jpg"
            height:           "./build/img/cube/height.jpg"
            metalness:        "./build/img/cube/metalness.jpg"
            normal:           "./build/img/cube/normal.jpg"
            roughness:        "./build/img/cube/roughness.jpg"
        }

        @geometry = new THREE.BoxGeometry( 2, 2, 2 )
        @material = new THREE.MeshBasicMaterial({ color: 0x368de3 })
        @mesh    = new THREE.Mesh( @geometry, @material )

        textureLoader = new THREE.TextureLoader()

        @options.scene.add @mesh

    
    # onUpdate: (elapsedTime) ->
    #     @mesh.rotation.x = elapsedTime * .4
    #     @mesh.rotation.y = elapsedTime * .4
