extends Resource
class_name ItemData

@export var item_name:String = "Basic Box" #Name, doesn't matter unless game/ability specifies
@export var weight: float = 1.0 #Tier or Cost to carry item
@export var Class:String = "Cardboard" #Sets Durability of item/reaction to certain things
@export var Durability:float = 100.0 #Health of item, if it hits 0 it blows up
@export var ItemCarrying: String = "more cardboard" #can determain placement requirements and will determain the ability
@export var ability:String = "Passive: All boxes above this one are 10% lighter" #the thing that can affect the game and increase the points gained
