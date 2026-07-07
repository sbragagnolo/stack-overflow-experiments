Class {
	#name : 'SOESingleThreadedServer',
	#superclass : 'ZnSingleThreadedServer',
	#instVars : [
		'shouldOverflow'
	],
	#category : 'StackOverflowExperiments',
	#package : 'StackOverflowExperiments'
}

{ #category : 'public' }
SOESingleThreadedServer >> shouldOverflow [

	^ shouldOverflow ifNil: [ false ]
]

{ #category : 'public' }
SOESingleThreadedServer >> shouldOverflow: aBoolean [

	 shouldOverflow := aBoolean
]

{ #category : 'public' }
SOESingleThreadedServer >> start [
	"Start me. I will start listening on my port for incoming HTTP connections.
	If I am running, I will first stop and thus effectively restart"

	self stop: false.
	self class default = self ifTrue: [ self register ].
	process := [ [ self listenLoop ] repeat ] forkAt: Processor highIOPriority named: self serverProcessName.
	process shouldOverflow: self shouldOverflow.
	self logStarted
]
