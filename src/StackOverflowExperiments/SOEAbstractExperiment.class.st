"
SOESingleCallExperiment singleThreadedAt: 8080 shouldOverflow: true . 
SOESingleCallExperiment multiThreadedAt: 8081 shouldOverflow: true .

SOEJustBeforeStackOverflowCallExperiment singleThreadedAt: 8090 shouldOverflow: true . 
SOEJustBeforeStackOverflowCallExperiment multiThreadedAt: 8091 shouldOverflow: true .
"
Class {
	#name : 'SOEAbstractExperiment',
	#superclass : 'Object',
	#instVars : [
		'uuid',
		'port',
		'serverClass',
		'shouldOverflow',
		'server'
	],
	#category : 'StackOverflowExperiments',
	#package : 'StackOverflowExperiments'
}

{ #category : 'accessing' }
SOEAbstractExperiment class >> multiThreadedAt: aPort shouldOverflow: aBoolean [

	^ self new
		  startAt: aPort with: SOEMultiThreadedServer shouldOverflow: aBoolean;
		  yourself
]

{ #category : 'accessing' }
SOEAbstractExperiment class >> singleThreadedAt: aPort shouldOverflow: aBoolean [

	^ self new
		  startAt: aPort with: SOESingleThreadedServer shouldOverflow: aBoolean;
		  yourself
]

{ #category : 'accessing' }
SOEAbstractExperiment >> handleRequest: request [
	" probably measuring something around here "

	^ self privateHandleRequest: request
]

{ #category : 'accessing' }
SOEAbstractExperiment >> log: aString [

	self logFile writeStream
		nextPutAll: DateAndTime now printString;
		tab;
		nextPutAll: aString;
		cr;
		close
]

{ #category : 'accessing' }
SOEAbstractExperiment >> logFile [

	^ (FileLocator localDirectory / 'soe' / uuid printString , 'log') asFileReference 
]

{ #category : 'accessing' }
SOEAbstractExperiment >> logPhase: aString [

	(FileLocator localDirectory / 'soe') asFileReference ensureCreateDirectory.

	self logFile writeStream
		nextPutAll:
			'========================================================================================================================================================================';
		cr;
		nextPutAll: 'UUID:';
		nextPutAll: uuid printString;
		tab;
		nextPutAll: 'PORT:';
		nextPutAll: port printString;
		tab;
		nextPutAll: 'ServerClass:';
		nextPutAll: serverClass name;
		tab;
		nextPutAll: 'Experiment:';
		nextPutAll: self class name;
		tab;
		nextPutAll: 'Stamp:';
		nextPutAll: DateAndTime now printString;
		cr;
		nextPutAll:
			'------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
		cr;
		nextPutAll: aString;
		cr;
		nextPutAll:
			'========================================================================================================================================================================';
		cr;
		close
]

{ #category : 'accessing' }
SOEAbstractExperiment >> logStarting: aString [

	(FileLocator localDirectory / 'soe') asFileReference ensureCreateDirectory.

	self logFile writeStream
		nextPutAll:
			'========================================================================================================================================================================';
		cr;
		nextPutAll: 'UUID:';
		nextPutAll: uuid printString;
		tab;
		nextPutAll: 'PORT:';
		nextPutAll: port printString;
		tab;
		nextPutAll: 'ServerClass:';
		nextPutAll: serverClass name;
		tab;
		nextPutAll: 'Experiment:';
		nextPutAll: self class name;
		tab;
		nextPutAll: 'Stamp:';
		nextPutAll: DateAndTime now printString;
		cr;
		nextPutAll:
			'------------------------------------------------------------------------------------------------------------------------------------------------------------------------';
		nextPutAll: aString;
		cr;
		nextPutAll:
			'========================================================================================================================================================================';
		cr;
		close
]

{ #category : 'accessing' }
SOEAbstractExperiment >> privateHandleRequest: aRequest [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
SOEAbstractExperiment >> startAt: aPort with: aServerClass shouldOverflow: aBoolean [

	uuid := UUID new.
	port := aPort.
	serverClass := aServerClass.
	shouldOverflow := aBoolean.
	server := serverClass defaultOn: aPort.
	server delegate: self.
	server shouldOverflow: aBoolean. 
	server start.
	self logPhase: 'Starting'.
]

{ #category : 'accessing' }
SOEAbstractExperiment >> stop [

	server stop.
	self logPhase: 'Stopping'
]
