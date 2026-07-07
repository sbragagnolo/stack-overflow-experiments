Class {
	#name : 'SOEJustBeforeStackOverflowCallExperiment',
	#superclass : 'SOEAbstractExperiment',
	#category : 'StackOverflowExperiments',
	#package : 'StackOverflowExperiments'
}

{ #category : 'accessing' }
SOEJustBeforeStackOverflowCallExperiment >> privateHandleRequest: aRequest [

	18500 slowFactorial.
	^ ZnResponse ok: (ZnEntity text: 'done')
]
