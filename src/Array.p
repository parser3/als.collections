############################################################
# $Id: Array.p,v 1.6 2013/11/29 01:27:31 misha Exp $

@CLASS
Als/Collections/Array



@create[data][i;v]
^if($data is "Array"){
	$h[^data.hash[]]
}{
	^switch[$data.CLASS_NAME]{
		^case[table]{
			$h[^data.hash{^uValue.offset[]}]
		}
		^case[hash]{
			$h[^hash::create[]]
			$i(0)
			^data.foreach[;v]{$h.[$i][$v]$i($i+1)}
		}
		^case[DEFAULT]{
			^if(def $data){
				$h[$.0[$data]]
			}{
				$h[^hash::create[]]
			}
		}
	}
}
$iCurrentIndex(0)



@json-string[hParams][result;v]
$result[[^h.foreach[;v]{^json:string[$v;$hParams]}[,]]]



@count[]
$result($h)



@GET_current[]
$result[$h.$iCurrentIndex]



@GET_DEFAULT[sIndex]
$result[^self.at[$sIndex]]



@foreach[sValueName;jCode;sSeparator][k;v]
^if(def $sValueName){
	$result[^h.foreach[;v]{$caller.[$sValueName][$v]$jCode}[$sSeparator]]
}{
	$result[^h.foreach[;]{$jCode}[$sSeparator]]
}



@list[sKey;jDefault;sEncloser][v]
^if(def $sEncloser){
	$result[^h.foreach[;v]{${sEncloser}${v.$sKey}$sEncloser}[,]]
}{
	$result[^h.foreach[;v]{$v.$sKey}[,]]
}
^if(!def $result){
	$result[$jDefault]
}



@add[uValue][result]
$h.[^eval($h)][$uValue]
$result[]



@GET[sMode][result]
^switch[$sMode]{
	^case[hash]{$result[$h]}
	^case[bool]{$result($h>0)}
	^case[def]{$result(true)}
	^case[expression;double;int]{$result($h)}
	^case[DEFAULT]{^throw[$self.CLASS_NAME;The object can't be used in mode '$sMode']}
}



@hash[sKey][result;v]
^if(def $sKey){
	$result[^h.foreach[;v]{$.[$v.$sKey][$v]}]
}{
	$result[^hash::create[$h]]
}



@select[jCondition][iIndex;v]
$result[^reflection:create[$self.CLASS_NAME;create]]
$iIndex($iCurrentIndex)
^h.foreach[iCurrentIndex;v]{^if($jCondition){^result.add[$v]}}
$iCurrentIndex($iIndex)



@contains[jCondition][result;iIndex;v]
$result(false)
$iIndex($iCurrentIndex)
^h.foreach[iCurrentIndex;]{^if($jCondition){$result(true)^break[]}}
$iCurrentIndex($iIndex)



@at[sIndex][result]
^if($sIndex eq "first" || $sIndex eq "last"){
	$result[^h._at[$sIndex]]
}{
	^self.checkRange($sIndex)
	$result[$h.$sIndex]
}



@set[iIndex;uValue]
^self.checkRange($iIndex)
$h.[$iIndex][$uValue]
$result[]



@removeAt[iIndex][result;i]
^self.checkRange($iIndex)
^for[i]($iIndex;$h-2){$h.[$i][$h.[^eval($i+1)]]}
^h.delete[^eval($h-1)]
$result[]



@moveNext[]
$result($iCurrentIndex < $h-1)
^if($result){
	^iCurrentIndex.inc[]
}


@movePrev[]
$result($iCurrentIndex > 0)
^if($result){
	^iCurrentIndex.dec[]
}


@clear[][result]
$h[^hash::create[]]
$iCurrentIndex(0)
$result[]



@offset[sType;iOffset][result;cnt]
^if(def $sType){
	^switch[$sType]{
		^case[set]{
			$iCurrentIndex($iOffset)
		}
		^case[cur]{
			$iCurrentIndex($iCurrentIndex+$iOffset)
		}
		^case[DEFAULT]{
			^throw[$self.CLASS_NAME;Type should be 'set' or 'cur']
		}
	}
	$cnt($h)
	^if($cnt){
		^if($iCurrentIndex < 0){
			$iCurrentIndex($iCurrentIndex % $cnt + $cnt)
		}
		^if($iCurrentIndex >= $cnt){
			$iCurrentIndex($iCurrentIndex % $cnt)
		}
	}{
		$iCurrentIndex(0)
	}
	$result[]
}{
	$result($iCurrentIndex)
}



@checkRange[iIndex][result]
^if($iIndex < 0 && $iIndex >= $h){
	^throw[$self.CLASS_NAME;Item index '$iIndex' is out of valid range ^[0..^eval($h)^)]
}
$result[]



@static:object2json[key;value;params]
$result[^value.json-string[$params]]
