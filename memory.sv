module memory(input logic clock);

string queue[$:16], temp_q[$];

int q_size;

int j,i,m,a;
longint unsigned debug,file, fp,clockcycle,count=0,last_req_time, temp_q_store_count[$];
string inputfile, str, q, inputScan;
logic [32:0] address;
logic [1:0] op;
longint unsigned temp_req_time[$] ;
int temp_operation[$], temp_address[$];


always @ (posedge clock)
begin
	count++;	
end

initial
begin
	$value$plusargs("debug=%d", debug);
	if($value$plusargs("tracefile=%s", inputfile))
	begin
		file = $fopen(inputfile, "r");
		if (file == 0)
		begin
			if (debug==1) 
			begin	
				$display ("ERROR: EMPTY FILE");
			end
		end
					
		else
		begin
			if(debug==1)
			begin
				while($fscanf(file,"%d %d %h",clockcycle,op,address)==3)
				begin
					$display("%d %d %h",clockcycle,op,address);
				end	
				$display("\n");	
			end
		end
	end
	file = $fopen(inputfile, "r");
	fp = $fopen(inputfile, "r");
	
	while(!$feof (file))
	begin
		$fgets(str,file);
		q=str;
		temp_q.push_back(q);
	end
	
	while($fscanf(fp,"%d %d %h",clockcycle,op,address)==3)
	begin
			temp_req_time.push_back(clockcycle);
			temp_operation.push_back(op);
			temp_address.push_back(address);
	end
		
	$display("NO.OF ITEMS IN QUEUE BEFORE REMOVAL%d",queue.size());
	$display("//////////////////////////////////////////////////");
			
end
			

always @ (posedge clock)
begin

	$value$plusargs("tracefile=%s", inputfile);
	file = $fopen(inputfile, "r");
	
	//$display("Count value from removal loop : %d", count);
	//$display("temp_q_store_count = %p", temp_q_store_count);
	
	if(count == temp_q_store_count[0]+100)
	begin
		if(debug == 1)
		begin
			queue = queue[1:$];
			$display("REMOVING AN ITEM FROM THE QUEUE @ %d\n",count);
		
			foreach(queue[i])
			begin
				$display("queue[%0d]=%d ",i ,queue[i]);
			end
					
			$display("//////////////////////////////////////////////");
			
			$display("NO.OF ITEMS IN QUEUE AFTER REMOVAL%d",queue.size());
			temp_q_store_count.pop_front();
		end
	
		else
			queue=queue;
			
	end 
		
end 


always @(posedge clock)
begin
	if(temp_req_time.size() != 0) 
	begin
		if(queue.size() < 16 && queue.size() != 0)
		begin
			if(temp_req_time[0] <= count)
			begin
				queue.push_back(temp_q.pop_front());
				temp_q_store_count.push_back(count);
				q_size = queue.size()-1;
				$display("%d -->  new queue[%0d] = %d",count+1,q_size ,queue[q_size]);
				temp_req_time.pop_front();
				last_req_time = count;
			end
		end 
		
		else if (queue.size() == 0) 
		begin
			count = temp_req_time[0];
			queue.push_back(temp_q.pop_front());
			temp_q_store_count.push_back(count);
			q_size = queue.size()-1;
			$display("%d -->  new queue[%0d] = %d",count,q_size ,queue[q_size]);
			temp_req_time.pop_front();
			last_req_time = count;
		end
	end 
end

endmodule






