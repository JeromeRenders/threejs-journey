# =============================================================================
# > SCENE - COMPONENTS: BASIC CUBE
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        
        @main = new THREE.AmbientLight(0xffffff, .5)
        @options.scene.add(@main)

        @point = new THREE.PointLight(0xffffff, .5)
        @point.position.set(2, 5, 5)
        @options.scene.add(@point)
        @createPointLightHelper(@point)

    
    createPointLightHelper: (light, size = 1) ->
        helper = new THREE.PointLightHelper(light, size)
        @options.scene.add(helper)