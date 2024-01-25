<NewDataSet>
  <sp_help>
    <Name>Module</Name>
    <Owner>dbo</Owner>
    <Type>user table</Type>
    <Created_datetime>2019-02-12T22:35:30.283+02:00</Created_datetime>
  </sp_help>
  <sp_help1>
    <Column_name>IdModule</Column_name>
    <Type>int</Type>
    <Computed>no</Computed>
    <Length>4</Length>
    <Prec>10   </Prec>
    <Scale>0    </Scale>
    <Nullable>no</Nullable>
    <TrimTrailingBlanks>(n/a)</TrimTrailingBlanks>
    <FixedLenNullInSource>(n/a)</FixedLenNullInSource>
  </sp_help1>
  <sp_help1>
    <Column_name>ModuleName</Column_name>
    <Type>varchar</Type>
    <Computed>no</Computed>
    <Length>100</Length>
    <Prec xml:space="preserve">     </Prec>
    <Scale xml:space="preserve">     </Scale>
    <Nullable>yes</Nullable>
    <TrimTrailingBlanks>no</TrimTrailingBlanks>
    <FixedLenNullInSource>yes</FixedLenNullInSource>
    <Collation>SQL_Latin1_General_CP1_CI_AS</Collation>
  </sp_help1>
  <sp_help1>
    <Column_name>Type</Column_name>
    <Type>varchar</Type>
    <Computed>no</Computed>
    <Length>50</Length>
    <Prec xml:space="preserve">     </Prec>
    <Scale xml:space="preserve">     </Scale>
    <Nullable>yes</Nullable>
    <TrimTrailingBlanks>no</TrimTrailingBlanks>
    <FixedLenNullInSource>yes</FixedLenNullInSource>
    <Collation>SQL_Latin1_General_CP1_CI_AS</Collation>
  </sp_help1>
  <sp_help1>
    <Column_name>Path</Column_name>
    <Type>varchar</Type>
    <Computed>no</Computed>
    <Length>4000</Length>
    <Prec xml:space="preserve">     </Prec>
    <Scale xml:space="preserve">     </Scale>
    <Nullable>yes</Nullable>
    <TrimTrailingBlanks>no</TrimTrailingBlanks>
    <FixedLenNullInSource>yes</FixedLenNullInSource>
    <Collation>SQL_Latin1_General_CP1_CI_AS</Collation>
  </sp_help1>
  <sp_help1>
    <Column_name>IdClient</Column_name>
    <Type>int</Type>
    <Computed>no</Computed>
    <Length>4</Length>
    <Prec>10   </Prec>
    <Scale>0    </Scale>
    <Nullable>yes</Nullable>
    <TrimTrailingBlanks>(n/a)</TrimTrailingBlanks>
    <FixedLenNullInSource>(n/a)</FixedLenNullInSource>
  </sp_help1>
  <sp_help1>
    <Column_name>Deleted</Column_name>
    <Type>char</Type>
    <Computed>no</Computed>
    <Length>1</Length>
    <Prec xml:space="preserve">     </Prec>
    <Scale xml:space="preserve">     </Scale>
    <Nullable>yes</Nullable>
    <TrimTrailingBlanks>no</TrimTrailingBlanks>
    <FixedLenNullInSource>yes</FixedLenNullInSource>
    <Collation>SQL_Latin1_General_CP1_CI_AS</Collation>
  </sp_help1>
  <sp_help2>
    <Identity>IdModule</Identity>
    <Seed>1</Seed>
    <Increment>1</Increment>
    <Not_x0020_For_x0020_Replication>0</Not_x0020_For_x0020_Replication>
  </sp_help2>
  <sp_help3>
    <RowGuidCol>No rowguidcol column defined.</RowGuidCol>
  </sp_help3>
  <sp_help4>
    <Data_located_on_filegroup>PRIMARY</Data_located_on_filegroup>
  </sp_help4>
  <sp_help5>
    <index_name>PK_Module</index_name>
    <index_description>clustered, unique, primary key located on PRIMARY</index_description>
    <index_keys>IdModule</index_keys>
  </sp_help5>
  <sp_help6>
    <constraint_type>PRIMARY KEY (clustered)</constraint_type>
    <constraint_name>PK_Module</constraint_name>
    <delete_action>(n/a)</delete_action>
    <update_action>(n/a)</update_action>
    <status_enabled>(n/a)</status_enabled>
    <status_for_replication>(n/a)</status_for_replication>
    <constraint_keys>IdModule</constraint_keys>
  </sp_help6>
</NewDataSet>