# Open libraries
library(shiny)
library(networkD3)
library(igraph)
library(shinythemes)

UIcharSet = list(vSize = "Font Size",
                 vOpacity = "Opacity",
                 nConnection="Number of Connection")

# Define UI for data upload
ui <- fluidPage(
  theme = shinytheme("superhero"),
  
  tags$head(
    tags$style('
               .nodetext{fill: #FFFFFF}
               .legend text{fill: #FFFFFF}
               ')
    ),
  
  # Assignment title
  br(),
  titlePanel("RO Network", windowTitle="RO_Network"),
  br(),
  # Create a sidebar for upload
  sidebarPanel(
    # 2 uploads for 2 types of data
    fileInput("file1", "Upload Department Labels:" ),
    fileInput("file2", "Upload Email Exchange:"),
    # User input for n connections
    sliderInput("nConnection", UIcharSet$nConnection, min=0, max=102, value=2, step=1, round=0),
    # Slider input for font size
    sliderInput("vSize", UIcharSet$vSize, min=1, max=50, value=16, step=1, round=0),
    #Slider input for opacity
    sliderInput("vOpacity", UIcharSet$vOpacity, min=0.1, max=1, value=0.9, step=0.2, round=0),
    # Input for number of top senders 
    numericInput("topsent", "Number of Top Senders: ", 1, min=1, max=NA),
    # Input for number of top receivers
    numericInput("topreceived", "Number of Top Receivers: ", 1, min=1, max=NA),
    # Input for the person with highest degree centrality
    numericInput("topdegree", "The nth Person with Highest Degree Centrality; ", 1, min=1, max=10),
    # Input for the person with highest betweenness centrality
    numericInput("topbetween", "The nth Person with Highest Betweenness Centrality: ", 1, min=1, max=10),
    # Input for the person with highest indegree centrality
    numericInput("topindegree", "The nth Person with Highest Indegree Centrality: ", 1, min=1, max=10),
  
    width = 2
  ),
  
  # Create main panel for results
  mainPanel(
    tabsetPanel(type="tabs",
                tabPanel("Preview",
                         fluidRow(
                           column(width=5,
                                  h5("Department Labels"),
                                  tableOutput('preview1')),
                           column(width=5,
                                  h5("Email Exchange"),
                                  tableOutput('preview2')))),
                tabPanel("Connection", forceNetworkOutput('network', height = "900px", width = "100%")),
                tabPanel("Sent Table", dataTableOutput('sent')),
                tabPanel("Received Table", dataTableOutput('received')),
                navbarMenu("2-hop Neighbors",
                           tabPanel("From Top Senders",
                                    h5("Top Senders"),
                                    fluidRow(textOutput('sent10')),
                                    fluidRow(simpleNetworkOutput('sentneighbors', height = "900px", width = "100%"))),
                           tabPanel("From Top Receivers",
                                    h5("Top Receivers"),
                                    fluidRow(textOutput('received10')),
                                    fluidRow(simpleNetworkOutput('receivedneighbors', height = "900px", width = "100%")))),
                navbarMenu("Degree Centrality",
                           tabPanel("Per Person", dataTableOutput('central')),
                           tabPanel("2-hop Graph",
                                    h5("The nth person with Highest Centrality"),
                                    fluidRow(textOutput('central10')),
                                    fluidRow(forceNetworkOutput('centralneighbors', height = "900px", width = "100%")))),
                navbarMenu("Betweenness Centrality",
                           tabPanel("Per Person", dataTableOutput('between')),
                           tabPanel("2-hop Graph",
                                    h5("The nth Person with Highest Betweenness "),
                                    fluidRow(textOutput('between10')),
                                    fluidRow(forceNetworkOutput('betweenneighbors', height = "900px", width = "100%")))),
                tabPanel("Department", dataTableOutput('department')),
                tabPanel("Discussion",
                         tags$br(),
                         tags$h4("Observations in comparing visualizations of degree centrality, betweenness centrality and in-degree centrality"),
                         tags$br(),
                         tags$br(),
                         tags$h5("When looking upto the 2-hop level of the top 10 employees in terms of degree centrality,
                                 betweenness centrality and in-degree centrality it can be easily concluded that these employees
                                 are central figues in the organization."),
                         tags$br(),
                         tags$h5("These employees reach almost all other employees with in 2 hops: 949, 955 and 947 out of the 1005 employees in the cases of
                                 degree centrality, betweenness centrality and in-degree centrality respectively. Hence information
                                 can be disseminated with in the organization fast. Further, this implies that the organization has a flat structure"),
                         tags$br(),
                         tags$h5("The employees 160, 86, 121, 107 and 62 are in the top 10 with respect to all 3 measures showing
                                 that they are central figures in the organization."),
                         tags$br(),
                         tags$h5("The employees 121, 434, 183, 64 and 128 have high in degree centrality but not in the top 10 of the
                                 other 2 measures. Hence, they can be considered as prominent figures in the organization who other employees connect with."),
                         tags$br(),
                         tags$h5("The employees 377 and 211 are in the top 10 in terms of betweenness but not the other 2 measures.
                                 Hence,they can be seen as employees that bridge nodes that are not connected to each other.
                                 They are probably in the higher levels of the hierarchy."),
                         tags$br(),
                         tags$h5("In summary, though this is a network of 1005 employees in 42 departments, it is a highly
                                 connected organization that can be reached across in a few hops.")  
                         
                         
                         )
    ),
    
    width = 10))

# Define server logic to execute the analysis
server <- function(input, output) {
  
  # Create basic function for 2 data files
  basicdf1 <- reactive({
    # Check whether the file is uploaded
    req(input$file1)
    # If yes, read the file, otherwise it only returns the metadata of the file
    df1 <- read.csv(input$file1$datapath, sep=" ", header=FALSE, stringsAsFactors=TRUE)
    colnames(df1) <- c("id", "dept")
    return(df1)
  })
  
  basicdf2 <- reactive({
    req(input$file2)
    df2 <- read.csv(input$file2$datapath, sep=" ", header=FALSE, stringsAsFactors=TRUE)
    colnames(df2) <- c("id", "target")
    return(df2)
  })
  
  ###################################################### 
  # Render table preview for the files
  output$preview1 <- renderTable({
    # Show the first 5 rows of the data
    df1 <- basicdf1()
    head(df1,5)      
    
  })
  
  # Similar data preview for file2
  output$preview2 <- renderTable({
    df2 <- basicdf2()
    head(df2, n=5)
  })
  
  #######################################################  
  # Show n connections with user input
  output$network <- renderForceNetwork({
    df1 <- basicdf1()
    df2 <- basicdf2()
    # Node size by total sent
    sentall <- data.frame(table(df2$id))
    colnames(sentall) <- c("id", "total sent")
    df1 <- merge(df1, sentall, by = "id", all.x = TRUE)
    df1[is.na(df1)] <- 0
    # Create a link table based on user input
    links <- df2[1:input$nConnection, ]
    # Combine ids of both source and target in a single-column tabl
    links1 <- stack(links[1:2])
    links1 <- links1[1]
    # Remove duplicates
    links1 <- unique(links1)
    colnames(links1) <- c("id")
    nodes <- merge(df1, links1, by = "id")
    forceNetwork(Links = links,
                 Nodes = nodes,
                 Source = "id",
                 Target = "target",
                 NodeID = "id",
                 Nodesize = "total sent",
                 Group = "dept",
                 fontSize = input$vSize,
                 fontFamily = "serif",
                 opacity = input$vOpacity,
                 height = NULL,
                 width = NULL,
                 zoom = TRUE,
                 legend = TRUE,
                 bounded = TRUE,
                 opacityNoHover = 0.7
    )
  })
  
  #######################################################  
  # Show number of emails sent by each person
  output$sent <- renderDataTable({
    df2 <- basicdf2()
    sentall <- data.frame(table(df2$id))
    colnames(sentall) <- c("ID", "Total Sent")
    sentall
  })
  
  ######## Objective 5 ###############################################  
  # Show number of emails received by each person
  output$received <- renderDataTable({
    df2 <- basicdf2()
    receivedall <- data.frame(table(df2$target))
    colnames(receivedall) <- c("ID", "Total Received")
    receivedall
  })
  
  #######################################################    
  ##### Only calculates 2-hop neighbors sent from top senders (1 direction)
  # Find top senders
  output$sent10 <- renderPrint({
    df1 <- basicdf1()
    df2 <- basicdf2()
    sentall <- data.frame(table(df2$id))
    colnames(sentall) <- c("id", "total")
    df1 <- merge(df1, sentall, by = "id", all.x=TRUE)
    df1[is.na(df1)] <- 0
    df1 <- df1[order(-df1$total), ]
    sent10 <- df1[1:input$topsent,]
    print(sent10$id)
  })
  
  # Find up to 2-hop neighbors for top senders
  output$sentneighbors <- renderSimpleNetwork({
    df1 <- basicdf1()
    df2 <- basicdf2()
    # Number of emails sent per person
    sentall <- data.frame(table(df2$id))
    colnames(sentall) <- c("id", "total")
    # Merge nodes table with number of emails sent
    df1 <- merge(df1, sentall, by = "id")
    # sort node table in descending order
    df1 <- df1[order(-df1$total), ]
    
    # Create a function to repeat this step for top x senders
    createLink <- function(x, df1, df2) {
      # Find top sender xth
      nodes <- df1[x,]
      # Create 1-hop neighbor links
      links1 <- merge(nodes, df2, by = "id")
      links1 <- data.frame(links1$id, links1$target)
      colnames(links1) <- c("id", "target")
      # Create 2-hop neighbor links
      id <- data.frame(links1$target)
      id <- unique(id)
      colnames(id) <- c("id")
      links2 <- merge(id, df2, by="id")
      links2 <- links2[!(links2$target %in% links1$target),]
      # Combine 1-hop with 2-hop
      links <- rbind(links1, links2)
      return(links)
    }
    # Create edge table
    edges <- data.frame(matrix(ncol=2,nrow=0))
    colnames(edges) <- c("id","target")
    
    for (x in 1:input$topsent) {
      edges <- rbind(edges, createLink(x, df1, df2))
    }
    
    # Graph 2-hop network
    simpleNetwork(Data = edges,
                  Source = "id",
                  Target = "target",
                  height = NULL,
                  width = NULL,
                  linkDistance = 100,
                  fontSize = 14,
                  fontFamily = "serif",
                  zoom = TRUE)
  })
  
  #######################################################    
  ##### Only calculates 2-hop neighbors sent from top receivers (1 direction)
  # Find top receivers
  output$received10 <- renderPrint({
    df1 <- basicdf1()
    df2 <- basicdf2()
    receivedall <- data.frame(table(df2$target))
    colnames(receivedall) <- c("id", "total")
    df1 <- merge(df1, receivedall, by = "id", all.x=TRUE)
    df1 <- df1[order(-df1$total), ]
    df1[is.na(df1)] <- 0
    received10 <- df1[1:input$topreceived,]
    print(received10$id)
  })
  
  # Find up to 2-hop neighbors for top receivers
  output$receivedneighbors <- renderSimpleNetwork({
    df1 <- basicdf1()
    df2 <- basicdf2()
    receivedall <- data.frame(table(df2$target))
    colnames(receivedall) <- c("id", "total")
    df1 <- merge(df1, receivedall, by = "id", all.x = TRUE)
    df1 <- df1[order(-df1$total), ]
    df1[is.na(df1)] <- 0
    
    # Create a function to repeat this step for 10 senders
    createLink <- function(x, df1, df2) {
      # Find top sender xth
      nodes <- df1[x,]
      # Create 1-hop neighbor links
      links1 <- merge(nodes, df2, by = "id")
      links1 <- data.frame(links1$id, links1$target)
      colnames(links1) <- c("id", "target")
      # Create 2-hop neighbor links
      id <- data.frame(links1$target)
      id <- unique(id)
      colnames(id) <- c("id")
      links2 <- merge(id, df2, by="id")
      links2 <- links2[!(links2$target %in% links1$target),]
      # Combine 1-hop with 2-hop
      links <- rbind(links1, links2)
      return(links)
    }
    
    edges <- data.frame(matrix(ncol=2,nrow=0))
    colnames(edges) <- c("id","target")
    
    for (x in 1:input$topreceived) {
      edges <- rbind(edges, createLink(x, df1, df2))
    }
    
    simpleNetwork(Data = edges,
                  Source = "id",
                  Target = "target",
                  height = NULL,
                  width = NULL,
                  linkDistance = 100,
                  fontSize = 14,
                  fontFamily = "serif",
                  zoom = TRUE)
  })
  
  # Create graph using igraph
  basicgraph <- reactive({
    df1 <- basicdf1()
    df2 <- basicdf2()
    graph <- graph.data.frame(df2, directed=TRUE, vertices = df1)
    V(graph)$degree <- degree(graph, mode = "all")
    V(graph)$indegree <- degree(graph, mode="in")
    V(graph)$between <- betweenness(graph)
    return(graph)
  })
  
  #######################################################   
  # Find degree centrality
  output$central <- renderDataTable({
    graph <- basicgraph()
    central <- data.frame(V(graph)$name, V(graph)$degree)
    colnames(central) <- c("ID", "Degree Centrality")
    central
  })
  
  # Find top degree centrality
  output$central10 <- renderPrint({
    graph <- basicgraph()
    central <- data.frame(V(graph)$name, V(graph)$degree)
    colnames(central) <- c("id", "degree")
    central <- central[order(-central$degree), ]
    central10 <- central[input$topdegree,]
    central10$id
  })
  
  
  # Graph 2-hop neighbors of top degree centrality
  output$centralneighbors <- renderForceNetwork({
    graph <- basicgraph()
    g <- make_ego_graph(graph, 2, order(V(graph)$degree, decreasing = TRUE)[1:input$topdegree], "all")[[input$topdegree]]
    t <- igraph_to_networkD3(g)
    t$nodes$group <- get.vertex.attribute(g, "dept")
    forceNetwork(Links = t$links,
                 Nodes = t$nodes,
                 NodeID = 'name',
                 Source = 'source',
                 Target = 'target',
                 Group = 'group',
                 fontSize = 18,
                 linkDistance = 100,
                 opacity = 0.9,
                 legend = TRUE,
                 bounded = TRUE,
                 zoom = TRUE)
  })
  
  #######################################################  
  # Find betweenness centrality
  output$between <- renderDataTable({
    graph <- basicgraph()
    between <- data.frame(V(graph)$name, V(graph)$between)
    colnames(between) <- c("ID", "Betweenness Centrality")
    return(between)
  })
  
  # Find top betweenness centrality
  output$between10 <- renderPrint({
    graph <- basicgraph()
    between <- data.frame(V(graph)$name, V(graph)$between)
    colnames(between) <- c("id", "between")
    between <- between[order(-between$between), ]
    between10 <- between[input$topbetween,]
    between10$id
  })
  
  # Graph 2-hop neighbors of top betweenness centrality
  output$betweenneighbors <- renderForceNetwork({
    graph <- basicgraph()
    g <- make_ego_graph(graph, 2, order(V(graph)$between, decreasing = TRUE)[1:input$topbetween], "all")[[input$topbetween]]
    t <- igraph_to_networkD3(g)
    t$nodes$group <- get.vertex.attribute(g, "dept")
    forceNetwork(Links = t$links,
                 Nodes = t$nodes,
                 NodeID = 'name',
                 Source = 'source',
                 Target = 'target',
                 Group = 'group',
                 fontSize = 18,
                 linkDistance = 100,
                 opacity = 0.9,
                 legend = TRUE,
                 bounded = TRUE,
                 zoom = TRUE)
  })
  
  ####################################################### 
  # Aggregate emails to the department level
  output$department <- renderDataTable({
    # Check whether the file is uploaded
    req(input$file1)
    req(input$file2)
    # If yes, read the file, otherwise it only returns the metadata of the file
    df1 <- read.csv(input$file1$datapath, sep=" ", header=FALSE)
    colnames(df1) <- c("source", "dept_source")
    df2 <- read.csv(input$file2$datapath, sep=" ", header=FALSE)
    colnames(df2) <- c("source", "target")
    df3 <- read.csv(input$file1$datapath, sep=" ", header=FALSE)
    colnames(df3) <- c("target", "dept_target")
    # Merge 3 tables
    df <- merge(df2, df3, by = "target")
    df <- merge(df, df1, by = "source")
    # Extract dept_souce and dept_target to "dept" table
    dept <- data.frame(df$dept_source, df$dept_target)
    # Find the number of emails exchange between each pair of department
    dept <- aggregate(list(total=rep(1,nrow(dept))), dept, length)
    colnames(dept) <- c("Dept_Source", "Dept_Target", "Total Emails")
    return(dept)
  })
  
  
}

shinyApp(ui = ui, server = server)