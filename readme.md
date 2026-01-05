# Course materials for MATH 130 at CSU Chico - Introduction to R 

snippet [
	[${1:label}](${2:location})

snippet ![
	![${1:label}](${2:location})

snippet r
	```{r}
	${0}
	```

snippet rcpp
	```{r, engine='Rcpp'}
	#include <Rcpp.h>
	using namespace Rcpp;
	
	${0}
	
	```


# Callout boxes
## blue notes
snippet note
	:::{.callout-note appearance=minimal}
	text
	
	:::

snippet bluebox
	:::{.callout-note title = ${1:"title"}}
	text
	
	:::

snippet tta
	:::{.callout-note appearance=minimal}
	### :question: :busts_in_silhouette: Turn and talk
	${1:text}
	:::
	
snippet slo
	:::{.callout-note title = "🎓 Learning Objectives" icon=false}
	
	:::

## green tips
snippet doit
	:::{.callout-tip title = "👉 Your Turn" icon=false}
	
	:::
	
snippet check
	:::{.callout-tip title = "✏️ Check your knowledge" icon=false}
	
	:::
	
snippet greenbox
	:::{.callout-tip title = ${1:"title"}}
	text
	
	:::

snippet exa
	:::{.callout-tip icon=true}
	### Example
	${1:text}
	:::
	
## red important
snippet def
	:::{.callout-important title = "Definition ${1}"}
	def
	:::

snippet redbox
	:::{.callout-important title = ${1:"title"}}
	text
	
	:::

snippet rad
	::: {.callout-warning appearance=simple}
	
	> note
	
	:::	
	
## orange warning
snippet yti
	:::{.callout-warning icon=false}
	### :star: You try it
	${1:text}
	:::

snippet orbox
	:::{.callout-warning icon=false appearance=minimal}
	stuff
	:::
	
snippet video
	:::{.callout-warning icon=false appearance=minimal title = "Optional Video"}
	stuff
	:::

snippet soln
	:::{.callout-warning icon=false collapse="true" appearance=minimal}
	### Solution
	:::

snippet orhide
	:::{.callout-warning icon=false collapse="true" appearance=minimal title = ${1:"title"}}
	stuff
	:::

	
# 2 columns
snippet column
	:::: {.columns}

	::: {.column width="45%"}
	Left stuff
	:::

	::: {.column width="10%"}
	:::

	::: {.column width="45%"}
	Right stuff
	:::

	::::

snippet cols
	:::: {.columns}
	
	::: {.column width="50%"}
	Left stuff
	:::
	
	::: {.column width="50%"}
	Right stuff
	:::
	
	::::
	
# panel tabset
snippet tabset
	::: {.panel-tabset}
	## header1
	
	Tab content
	
	## header2
	
	Tab content
	:::


# aside
snippet aside
	[]{.aside}

# dropdown
snippet solnd
	<details>
		<summary> Solution </summary>
	</details>

