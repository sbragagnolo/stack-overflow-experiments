Class {
	#name : 'SOEMultiThreadedServer',
	#superclass : 'ZnMultiThreadedServer',
	#instVars : [
		'shouldOverflow'
	],
	#category : 'StackOverflowExperiments',
	#package : 'StackOverflowExperiments'
}

{ #category : 'accessing' }
SOEMultiThreadedServer >> serveConnectionsOn: listeningSocket [
	"We wait up to acceptWaitTimeout seconds for an incoming connection.
	If we get one we wrap it in a SocketStream and #executeRequestResponseLoopOn: on it"

	| stream socket |
	socket := listeningSocket waitForAcceptFor: self acceptWaitTimeout.
	socket ifNil: [ ^ self noteAcceptWaitTimedOut ].
	stream := [ self withDynamicVariablesDo: [ self socketStreamOn: socket ] ]
		          on: ZnTooManyConcurrentConnections
		          do: [ ^ self ].
	([
		 [
			 [ self executeRequestResponseLoopOn: stream ] ensure: [
					 self logConnectionClosed: stream.
					 self closeSocketStream: stream ] ] ifCurtailed: [ socket destroy ] ]
		 forkAt: Processor lowIOPriority
		 named: self workerProcessName) shouldOverflow: self shouldOverflow
]

{ #category : 'accessing' }
SOEMultiThreadedServer >> shouldOverflow [

	^ shouldOverflow ifNil: [ false ]
]

{ #category : 'accessing' }
SOEMultiThreadedServer >> shouldOverflow: aBoolean [

	 shouldOverflow := aBoolean
]

{ #category : 'accessing' }
SOEMultiThreadedServer >> start [
	"Start me. I will start listening on my port for incoming HTTP connections.
	If I am running, I will first stop and thus effectively restart"

	self stop: false.
	self class default = self ifTrue: [ self register ].
	process := [ [ self listenLoop ] repeat ] forkAt: Processor highIOPriority named: self serverProcessName.
	process shouldOverflow: self shouldOverflow.
	self logStarted
]
