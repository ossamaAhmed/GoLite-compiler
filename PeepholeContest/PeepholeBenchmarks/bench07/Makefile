ROOMACTIONS = RoomAction.java BFRoomAction.java FeastRoomAction.java CoinRoomAction.java EmptyRoomAction.java GrueRoomAction.java TreasureRoomAction.java FactorialRoomAction.java HuntRoomAction.java ExitRoomAction.java JokeRoomAction.java

SRC = $(ROOMACTIONS) Room.java GrueHunt.java InGenerate.java

joos: $(SRC)
	$(PEEPDIR)/joosc $(SRC)

GrueHunt: $(SRC)
	javac $(SRC)


gen:
	javac InGenerate.java
	java InGenerate > in1

clean:
	rm *.class *.j

