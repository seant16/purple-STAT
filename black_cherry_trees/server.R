library(shiny)
library(boot)
library(ggplot2)

shinyServer(function(input, output) {
  
  output$treedist <- renderPlot({
    if(input$dist=='a'){
     p1 <- ggplot(trees, aes(x=Girth)) + ggtitle("Histogram of Girth")+
        geom_histogram(aes(y=..density..), colour="black", fill="#56B4E9")+
        geom_density(alpha=.25, fill="#FF6666") 
    }
    
    if(input$dist=='b'){
      p1 <- ggplot(trees, aes(x=Height)) + 
        geom_histogram(aes(y=..density..), colour="black", fill="#009E73")+
        geom_density(alpha=.25, fill="#FF6666") 
    }
    
    if(input$dist=='c'){
      p1 <- ggplot(trees, aes(x=Volume)) + 
        geom_histogram(aes(y=..density..), colour="black", fill="#F0E442")+
        geom_density(alpha=.25, fill="#FF6666") 
    }
    print(p1)
    
  })
  
    
  output$treeplot <- renderPlot({
    if(input$p=='a'){
      p2 <- ggplot(trees, aes(x=Height, y=Volume)) + geom_point(size=3)
    }
    
    if(input$p=='b'){
      p2<-ggplot(trees, aes(x=Height, y=Girth)) + geom_point(size=3)

    }
    
      print(p2)
    
    })

   output$trees_stats <- renderDataTable({
     trees
   })
   
   #output$distPlot <- renderPlot({
  #   hist(trees$Height)
  # })
   
   #output$HCI <- renderText(({
  #    paste("A ", input$Height_CI, "% CI on the mean height of the tree is: ",
  #        mean(trees$Height)-qt(1-(1-input$Height_CI/100)/2.0,df=length(trees$Height)-1)*sd(trees$Height)/sqrt(length(trees$Height)), 
  #             mean(trees$Height)+qt(1-(1-input$Height_CI/100)/2.0,df=length(trees$Height)-1)*sd(trees$Height)/sqrt(length(trees$Height))
  #                )
  #}))
   
   observeEvent(input$runBoot, {
     volume_estimate = function(data, indices){
       d = data[indices, ]
       H_relationship = lm(d$Volume~d$Height, data = d)
       H_r_sq = summary(H_relationship)$r.square
       G_relationship = lm(d$Volume~d$Girth, data = d)
       G_r_sq = summary(G_relationship)$r.square
       G_H_ratio = d$Girth / d$Height
       G_H_relationship = lm(d$Volume~G_H_ratio, data = d)
       G_H_r_sq = summary(G_H_relationship)$r.square
       combined_relationship = lm(d$Volume~d$Height + d$Girth, data = d)
       combined_r_sq = summary(combined_relationship)$r.square
       combined_2_relationship = lm(d$Volume~d$Height +d$Girth + G_H_ratio, data = d)
       combined_2_r_sq = summary(combined_2_relationship)$r.square
       relationships = c(H_r_sq, G_r_sq, G_H_r_sq, combined_r_sq, combined_2_r_sq)
       return(relationships)
     }
     
     results = boot(data=trees, statistic=volume_estimate, R=input$reps)
     confidence_interval_H = boot.ci(results, index = 1, conf = input$bootstrap_ci/100, type = 'bca')
     
     output$results <- renderPlot({
       plot(results)
     })
     
     output$resultsText <- renderPrint({
       print(results)
     })
     
     output$bootCI <- renderPrint({
       print(confidence_interval_H)
     })
     
   })
   
     
 })
  
   
 


