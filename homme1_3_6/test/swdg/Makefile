QUEUE        =  cqsub
DEBUGQUEUE   =  cqsub -q debug
NP           =  96            
COUNT        =  192
TIME         =  2:00:00
COMODE       =  co
VNMODE       =  vn
EXECUTE      =  swdgx
OUTPUT_PREFIX_CO=  corun
OUTPUT_PREFIX_VN=  vnrun
OUTPUT_PREFIX_D =  debug
OUTPUT_PREFIX_S =  srun

CP = cp
LN = ln -s


one: 
	@echo running case one	
	$(CP) ./input1.nl ./input.nl
	$(DEBUGQUEUE) -n $(NP) -t $(TIME) -O $(OUTPUT_PREFIX_D) -m $(VNMODE) -c $(COUNT) $(EXECUTE)
two: 
	@echo running case two	
	$(CP) ./input2.nl ./input.nl
	$(DEBUGQUEUE) -n $(NP) -t $(TIME) -O $(OUTPUT_PREFIX_D) -m $(VNMODE) -c $(COUNT) $(EXECUTE)
five: 
	@echo running case five	
	$(CP) ./input5.nl ./input.nl
	$(DEBUGQUEUE) -n $(NP) -t $(TIME) -O $(OUTPUT_PREFIX_D) -m $(VNMODE) -c $(COUNT) $(EXECUTE)

clean:
	rm -rf *.error *.output *.errors *~ fort.* swtc*.* core.* 
