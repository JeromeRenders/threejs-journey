# =============================================================================
# > SCENE - COMPONENTS: AXES HELPER
# > https://threejs.org/docs/#api/en/helpers/AxesHelper
# =============================================================================

import * as THREE    from "three"
import gsap          from "gsap"

import BaseComponent from "./BaseComponent.coffee"


export default class extends BaseComponent

    constructor: (@options) ->
        axesHelper = new THREE.AxesHelper(1000)
        @options.scene.add axesHelper
