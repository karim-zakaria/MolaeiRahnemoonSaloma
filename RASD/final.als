---------------- Register Sig---------------------
sig FiscalCode{}  
sig Username{} 
sig Password{}  
sig PhoneNumber{}
sig Name{}
sig Surename{}
sig Birthday{}
sig Gender{}

sig Registration{ 
	fiscalCode: one FiscalCode,
  	username: one Username, 
  	password: one Password,
	phoneNumber: one PhoneNumber
  	} 
--------------------------------------------
sig Authority{}
---------------- Report Sig---------------------
sig Picture{}
sig PlateNumber{}
sig Time{ 
timestamp: one Int
	}
sig TypeOfViolation{} -- for simplicity we do not consider string in it
sig Location{ 
latitude: one Int,  
longitude: one Int -- change
	}{latitude >= -3 and latitude <= 3 and longitude >= -6 and longitude <= 6 } 

sig Report{
	user: one User,
	picture: one Picture,
	plateNumber: one PlateNumber,
	time: one Time,
	typeOfViolation: one TypeOfViolation,
	location: one Location
	}
--------------------------------------------
---------------- Data-Channel  Sig---------------------

abstract sig Data{}
abstract sig DataFlow{}
abstract sig Channel{}

sig Statistics extends Data{}
sig Interventions extends Data{}
sig AccidentReport extends Data{}

sig AuthorityToSystem extends DataFlow{}
sig SystemToAuthority extends DataFlow{}


sig ChannelOne extends Channel{
	dataflow: one AuthorityToSystem,
	data: some AccidentReport,
	owner: one Authority
	}

sig ChannelTwo extends Channel{
	dataflow: one SystemToAuthority,
	data1: some Report,
	data2: some Statistics,
	data3: some Interventions,
	owner: one Authority
	}
---------------- Request  Sig---------------------
abstract sig Request{}

sig RequestForProfile extends Request{
	user: one User
	}

sig RequestForSafeArea extends Request{
	location: one Location
	}
--------------------------------------------
abstract sig Customer{ 
  registration: one Registration  
	} 
 
sig User extends Customer{ 
  	name: one Name, 
  	surename: one Surename, 
 	birthday: lone Birthday, 
	gender: lone Gender
	} 


 --------------------------------------------
---------------- User Facts ---------------------

--All Name have to be associated to a User 
fact NameUserConnection{ 
  	all n: Name | some u: User | n in u.name
}
--All Surename have to be associated to a User 
fact SurenameUserConnection{ 
  	all s: Surename | some u: User | s in u.surename
}
--All Birthday have to be associated to a User 
fact BirthdayUserConnection{ 
  	all b: Birthday | some u: User | b in u.birthday
}
--All Gender have to be associated to a User 
fact GenderUserConnection{ 
  	all g: Gender | some u: User | g in u.gender
}
 --------------------------------------------
---------------- Registration Facts ---------------------

--All FiscalCodes have to be associated to a Registration 
fact FiscalCodeRegistrationConnection{ 
  	all fc: FiscalCode | some r: Registration | fc in r.fiscalCode 
} -- change ittttttttttttttt fc with user

--All FiscalCodes have to be associated to a User 
fact FiscalCodeUserConnection{ 
  	all fc: FiscalCode | some u: User | fc in u.registration.fiscalCode 
} 

--All PhoneNumber have to be associated to a Registration 
fact PhoneNumberRegistrationConnection{ 
  	all p: PhoneNumber | some r: Registration | p in r.phoneNumber
} 

--All PhoneNumber have to be associated to a User 
fact PhoneNumberUserConnection{ 
  	all p: PhoneNumber | some u: User | p in u.registration.phoneNumber
} 

--All Usernames have to be associated to a Registration  
fact UsernameRegistrationConnection{ 
 	all u: Username | some r: Registration | u in r.username  } 

--All Passwords have to be associated to a Registration 
fact PasswordRegistrationConnection{ 
  all p: Password | some r: Registration | p in r.password 
} 
 

--Every Customer has a unique username 
fact NoSameUsername { 
  no disj c1,c2: Customer | c1.registration.username = c2.registration.username  } 
 
--Every User has a unique FiscalCode 
fact NoSameFiscalCode { 
  no disj r1,r2 : Registration | r1.fiscalCode = r2.fiscalCode 
} 


 --------------------------------------------
---------------- Report Facts ---------------------

--All Dates have to be associated to a report 
fact DateReportConnection{ 
  all t: Time | some re: Report | t in re.time
} 
--Picutre have to be associated to a report 
fact PictureReportConnection{ 
  all p: Picture | some re: Report | p in re.picture
} 
--PlateNumber have to be associated to a report 
fact PlateNumberReportConnection{ 
  all pl: PlateNumber | some re: Report | pl in re.plateNumber
} 
--ViolationType have to be associated to a report 
fact ViolationReportConnection{ 
  all v: TypeOfViolation | some re: Report | v in re.typeOfViolation
} 

--Location have to be associated to a report 
fact LocationReportConnection{ 
  all v: Location | some re: Report | v in re.location
} 
--All Reports have to be associated to a User  
fact ReportUserConnection { 
  all re: Report | some u: User | u in re.user
	}

 --------------------------------------------
---------------- Request Facts ---------------------
--All Profile request have to be associated to a user 
fact PrequestConnection{ 
  all pr: RequestForProfile | some u: User | (pr.user = u)
} 

--All SafeArea request have to be associated to a location 
fact SArequestConnection{ 
  all rsa: RequestForSafeArea | some l: Location | (rsa.location = l)
} 

 --------------------------------------------
---------------- Data-Channel Facts ---------------------
fact AccidentReportConnection{ 
  all a: AccidentReport | some ch: ChannelOne | a in ch.data
} 

fact DataFlowChannelOneConnection{ 
  all a: AuthorityToSystem | some ch: ChannelOne | a in ch.dataflow
}

fact DataFlowChannelTwoConnection{ 
  all a: SystemToAuthority | some ch: ChannelTwo | a in ch.dataflow
}
 --------------------------------------------
fact RegistrationCustomerConnection { 
  all r: Registration | some c: Customer | r in c.registration 
} 

---------------- Predicates ---------------------
pred world1{
	#Report = 2
	#User = 1


	(some disj re1, re2: Report | some disj u1: User | u1 in re1.user and u1 in re2.user)

}
run world1 for 10 but 0 Interventions, 0 AccidentReport, 0 Statistics, 0 Authority


pred world2{
	#Report = 1
	#User = 1
	#Authority = 1
	#ChannelOne = 1
	#ChannelTwo = 1
	#Interventions = 1
	#AccidentReport = 3
	#Statistics = 1

}
run world2 for 5 but 0 RequestForSafeArea, 0 RequestForProfile



pred world3{
	#Report = 1
	#User = 2

}
run world3 for 3 but 0 Authority, 0 Interventions, 0 AccidentReport, 0 Statistics
