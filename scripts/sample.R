


x<- data.frame(x = runif(100000),
                 strata = rep(c(1,2,3,4),(100000 * .25)), 
                 index = 1:100000)


sample = x$index %in% as.vector(unlist(by(x, x$strata, function(sub) sample(sub$index, size = 0.1*nrow(sub)))))



sample = x$index %in% as.vector(unlist(by(x, x$strata, 
                                          function(sub) if (sub$index == 1)
                                            {sample(sub$index, size = 0.1*nrow(sub))}
                                          if (sub$index == 2)
                                            {sample(sub$index, size = 0.2*nrow(sub))}
                                          )))




df <- x[sample,]


A <- data.frame(index = 1:207)
B <- data.frame(index = 208:386)
C <- data.frame(index = 387:486)
D <- data.frame(index = 487:586)
df <- rbind(A,B,C,D)
L <- sapply(list(A$index, B$index, C$index, D$index), length)

x <- sample(c(A$index, B$index, C$index, D$index),
            size = 20,
            prob = rep(c(1/2, 1/6, 1/6, 1/6) / L, L),
            replace = F)

df$x <- runif(nrow(df))
df$pik <- rep(c(1/2, 1/6, 1/6, 1/6) / L, L)

final <- df[x,]

head(final)







