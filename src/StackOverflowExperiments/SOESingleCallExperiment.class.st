Class {
	#name : 'SOESingleCallExperiment',
	#superclass : 'SOEAbstractExperiment',
	#category : 'StackOverflowExperiments',
	#package : 'StackOverflowExperiments'
}

{ #category : 'accessing' }
SOESingleCallExperiment >> privateHandleRequest: aRequest [
	1halt.
	1 slowFactorial.
	^ ZnResponse ok: (ZnEntity text: 'done')
]
