@CLASS
Als/Collections/Stack


@create[]
$h[^hash::create[]]
$i(0)



@push[uValue][result]
^i.inc[]
$h.$i[$uValue]
$result[]



@pop[][result]
^if(!$i){
	^throw[$self.CLASS_NAME;Stack is empty]
}
$result[$h.$i]
^h.delete[$i]
^i.dec[]



@count[]
$result($h)
