<?php  if ( ! defined('BASEPATH')) exit('No direct script access allowed');
/**
* MANUSGI CBT
* Syaifuddin Zuhri
* zuhrideveloper@gmail.com
* manusunangiri@gmail.com
*/
class Cbt_tes_user_model extends CI_Model{
	public $table = 'cbt_tes_user';
	
	
    function save($data){
        $this->db->insert($this->table, $data);
        return $this->db->insert_id();
    }
    
    function delete($kolom, $isi){
        $this->db->where($kolom, $isi)
                 ->delete($this->table);
    }
    
    function update($kolom, $isi, $data){
        $this->db->where($kolom, $isi)
                 ->update($this->table, $data);
    }

    function update_menit($tesuser_id, $waktu){
        $sql = 'UPDATE cbt_tes_user SET tesuser_creation_time=TIMESTAMPADD(MINUTE, '.$waktu.', tesuser_creation_time) WHERE tesuser_id="'.$tesuser_id.'"';
        $this->db->query($sql);
    }
    
    function count_by_kolom($kolom, $isi){
        $this->db->select('COUNT(*) AS hasil')
                 ->where($kolom, $isi)
                 ->from($this->table);
        return $this->db->get();
    }

    /**
     * menghitung testuser yang masih aktif dengan status==1 dan waktu masih belum habis
     *
     * @param      string  $tesuser_id  The tesuser identifier
     *
     * @return     <type>  Number of by status waktu.
     */
    function count_by_status_waktu($tesuser_id){
		$now = date('Y-m-d H:i:s');
        $this->db->select('COUNT(tesuser_id) AS hasil')
                 ->where('(tesuser_id="'.$tesuser_id.'" AND tesuser_status="1" AND TIMESTAMPADD(MINUTE, tes_duration_time, tesuser_creation_time)>"'.$now.'")')
                 ->from($this->table)
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id');
        return $this->db->get();
    }

    /**
     * menghitung testuser yang masih aktif dengan status==1 dan waktu masih belum habis
     * berdasarkan waktu yang php, bukan waktu mysql
     * revisi 2018-11-15
     * @param      string  $tesuser_id  The tesuser identifier
     *
     * @return     <type>  Number of by status waktu.
     */
    function count_by_status_waktuuser($tesuser_id, $waktuuser){
        $this->db->select('COUNT(tesuser_id) AS hasil')
                 ->where('(tesuser_id="'.$tesuser_id.'" AND tesuser_status="1" AND TIMESTAMPADD(MINUTE, tes_duration_time, tesuser_creation_time)>"'.$waktuuser.'")')
                 ->from($this->table)
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id');
        return $this->db->get();
    }

    function get_by_user_status($user_id){
        $this->db->where('tesuser_user_id="'.$user_id.'" AND tesuser_status!=4')
                 ->from($this->table)
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id');
        return $this->db->get();
    }

    function get_by_user_tes_limit($user_id, $tes_id){
        $this->db->where('tesuser_user_id="'.$user_id.'" AND tesuser_tes_id="'.$tes_id.'" AND tesuser_status=1')
                 ->from($this->table)
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->limit(1);
        return $this->db->get();
    }

    function count_by_user_tes($user_id, $tes_id){
        $this->db->select('COUNT(*) AS hasil')
                 ->where('tesuser_user_id="'.$user_id.'" AND tesuser_tes_id="'.$tes_id.'"')
                 ->from($this->table);
        return $this->db->get();
    }

    function count_by_user_tes_selesai($user_id, $tes_id){
        $this->db->select('COUNT(*) AS hasil')
                 ->where('tesuser_user_id="'.$user_id.'" AND tesuser_tes_id="'.$tes_id.'" AND tesuser_status=4')
                 ->from($this->table);
        return $this->db->get();
    }
	
    function get_by_user_tes($user_id, $tes_id){
        $this->db->where('tesuser_user_id="'.$user_id.'" AND tesuser_tes_id="'.$tes_id.'"')
                 ->from($this->table)
                 ->limit(1);
        return $this->db->get();
    }

	function get_by_kolom($kolom, $isi){
        $this->db->where($kolom, $isi)
                 ->from($this->table);
        return $this->db->get();
    }

    function get_by_group(){
        $this->db->from($this->table)
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->order_by('tes_id', 'DESC')
                 ->group_by('tesuser_tes_id');
        return $this->db->get();
    }
	
	function get_by_kolom_limit($kolom, $isi, $limit){
        $this->db->where($kolom, $isi)
                 ->from($this->table)
				 ->limit($limit);
        return $this->db->get();
    }

    function get_by_tes_group_urut_tanggal($tes_id, $grup_id, $urutkan, $tanggal, $keterangan){
        $sql = 'tesuser_creation_time>="'.$tanggal[0].'" AND tesuser_creation_time<="'.$tanggal[1].'"';
		
        if($tes_id!='semua'){
            $sql = $sql.' AND tes_id="'.$tes_id.'"';
        }
        if($grup_id!='semua'){
            $sql = $sql.' AND user_grup_id="'.$grup_id.'"';
        }
        $order = '';
        if($urutkan=='tertinggi'){
            $order = 'nilai DESC';
        }else if($urutkan=='terendah'){
            $order = 'nilai ASC';
        }else if($urutkan=='nama'){
            $order = 'user_firstname ASC';
        }else if($urutkan=='waktu'){
            $order = 'tesuser_creation_time DESC';
        }else{
            $order = 'tesuser_tes_id ASC';
        }
		
		if(!empty($keterangan)){
			$sql = $sql.' AND user_detail LIKE "%'.$keterangan.'%"';
		}

        $this->db->select('cbt_tes_user.*, cbt_tes.*, cbt_user.*, cbt_user_grup.grup_nama, SUM(`cbt_tes_soal`.`tessoal_nilai`) AS nilai ')
                 ->where('( '.$sql.' )')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id', 'right')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id', 'left')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id', 'left')
                 ->group_by('cbt_tes_user.tesuser_id')
                 ->order_by($order);
        return $this->db->get();
    }
	
	function get_by_tes_group($tes_id, $grup_id){
        $sql = 'tesuser_tes_id="'.$tes_id.'" AND user_grup_id="'.$grup_id.'"';

        $this->db->select('cbt_tes_user.*, cbt_tes.tes_nama, cbt_user.*, cbt_user_grup.grup_nama')
                 ->where('( '.$sql.' )')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->order_by('cbt_user.user_firstname', 'ASC');
        return $this->db->get();
    }

    function get_nilai_by_tes_user($tes_id, $user_id){
        $this->db->select('SUM(`cbt_tes_soal`.`tessoal_nilai`) AS nilai')
                 ->where('(tesuser_tes_id="'.$tes_id.'" AND tesuser_user_id="'.$user_id.'")')
                 ->from($this->table)
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id');
        return $this->db->get();
    }
	
	/**
	* datatable untuk hasil tes yang sudah mengerjakan
	*
	*/
	function get_datatable($start, $rows, $tes_id, $grup_id, $urutkan, $tanggal, $keterangan, $search){
        $sql = 'tesuser_creation_time>="'.$tanggal[0].'" AND tesuser_creation_time<="'.$tanggal[1].'" AND user_firstname LIKE "%'.$search.'%"';
		
        if($tes_id!='semua'){
            $sql = $sql.' AND tesuser_tes_id="'.$tes_id.'"';
        }
        if($grup_id!='semua'){
            $sql = $sql.' AND user_grup_id="'.$grup_id.'"';
        }
        $order = '';
        if($urutkan=='tertinggi'){
            $order = 'nilai DESC';
        }else if($urutkan=='terendah'){
            $order = 'nilai ASC';
        }else if($urutkan=='nama'){
            $order = 'user_firstname ASC';
        }else if($urutkan=='waktu'){
            $order = 'tesuser_creation_time DESC';
        }else{
            $order = 'tesuser_tes_id ASC';
        }
		
		if(!empty($keterangan)){
			$sql = $sql.' AND user_detail LIKE "%'.$keterangan.'%"';
		}

		$this->db->select('cbt_tes_user.*,cbt_user_grup.grup_nama, cbt_tes.*, cbt_user.*, SUM(`cbt_tes_soal`.`tessoal_nilai`) AS nilai ')
                 ->where('( '.$sql.' )')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->group_by('cbt_tes_user.tesuser_id')
				 ->order_by($order)
                 ->limit($rows, $start);
        return $this->db->get();
	}
    
    function get_datatable_count($tes_id, $grup_id, $urutkan, $tanggal, $keterangan, $search){
        $sql = 'tesuser_creation_time>="'.$tanggal[0].'" AND tesuser_creation_time<="'.$tanggal[1].'" AND user_firstname LIKE "%'.$search.'%"';
		
        if($tes_id!='semua'){
            $sql = $sql.' AND tesuser_tes_id="'.$tes_id.'"';
        }
        if($grup_id!='semua'){
            $sql = $sql.' AND user_grup_id="'.$grup_id.'"';
        }
		
		if(!empty($keterangan)){
			$sql = $sql.' AND user_detail LIKE "%'.$keterangan.'%"';
		}

		$this->db->select('COUNT(*) AS hasil')
                 ->where('( '.$sql.' )')
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id', 'right')
                 ->from($this->table);
        return $this->db->get();
	}

    /**
     * Question Type
     * 1 = ganda
     * 2 = essay
     *
     * @param      <type>  $start   The start
     * @param      <type>  $rows    The rows
     * @param      string  $tes_id  The tes identifier
     * @param      string  $order   The order
     *
     * @return     <type>  The datatable evaluasi.
     */
    function get_datatable_evaluasi($start, $rows, $tes_id, $urutkan){
        $sql = '';
        if(!empty($tes_id)){
            $sql = ' AND tesuser_tes_id="'.$tes_id.'"';
        }
        $order = '';
        if($urutkan=='soal'){
            $order = 'tessoal_soal_id ASC';
        }else{
            $order = 'tesuser_id ASC';
        }

        $this->db->select('cbt_tes_soal.tessoal_id, cbt_tes_soal.tessoal_jawaban_text, cbt_tes.*, cbt_soal.*, cbt_user.user_name, cbt_user.user_firstname')
                 ->where('(soal_tipe="2" AND tessoal_jawaban_text IS NOT NULL AND tessoal_comment IS NULL '.$sql.' )')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id')
                 ->order_by($order)
                 ->limit($rows, $start);
        return $this->db->get();
    }

    function get_evaluasi_export($tes_id, $urutkan){
        $sql = '';
        if(!empty($tes_id)){
            $sql = ' AND tesuser_tes_id="'.$tes_id.'"';
        }
        $order = '';
        if($urutkan=='soal'){
            $order = 'tessoal_soal_id ASC';
        }else{
            $order = 'tesuser_id ASC';
        }

        $this->db->select('cbt_tes_soal.tessoal_id, cbt_tes_soal.tessoal_jawaban_text, cbt_tes.*, cbt_soal.*, cbt_user.user_name, cbt_user.user_firstname, cbt_user_grup.grup_nama')
                 ->where('(soal_tipe="2" AND tessoal_jawaban_text IS NOT NULL AND tessoal_comment IS NULL '.$sql.' )')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id')
                 ->order_by($order);
        return $this->db->get();
    }

    function get_evaluasi_export_soal($tes_id, $urutkan){
        $order = '';
        if($urutkan=='soal'){
            $order = 'cbt_soal.soal_id ASC';
        }else{
            $order = 'cbt_tes_soal.tessoal_order ASC';
        }

        $this->db->select('cbt_soal.soal_id, cbt_soal.soal_detail, MIN(cbt_tes_soal.tessoal_order) AS nomor_soal')
                 ->where('(tesuser_tes_id="'.$tes_id.'" AND soal_tipe="2" AND tessoal_jawaban_text IS NOT NULL)')
                 ->from($this->table)
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id')
                 ->group_by('cbt_soal.soal_id')
                 ->order_by($order);
        return $this->db->get();
    }

    function get_evaluasi_export_peserta($tes_id, $urutkan){
        $order = '';
        if($urutkan=='user'){
            $order = 'cbt_user.user_firstname ASC';
        }else{
            $order = 'cbt_tes_user.tesuser_id ASC';
        }

        $this->db->select('
                    cbt_tes.tes_nama,
                    cbt_tes_user.tesuser_id,
                    cbt_user.user_name,
                    cbt_user.user_firstname,
                    cbt_user_grup.grup_nama,
                    cbt_soal.soal_id,
                    cbt_tes_soal.tessoal_nilai,
                    cbt_tes_soal.tessoal_jawaban_text
                ')
                 ->where('(tesuser_tes_id="'.$tes_id.'" AND soal_tipe="2" AND tessoal_jawaban_text IS NOT NULL)')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id')
                 ->order_by($order.', cbt_tes_soal.tessoal_order ASC');
        return $this->db->get();
    }

    function get_komposisi_soal($tes_id){
        $this->db->select('
                    SUM(tset_jumlah) AS total_soal,
                    SUM(CASE WHEN tset_tipe="2" THEN tset_jumlah ELSE 0 END) AS total_essay,
                    SUM(CASE WHEN tset_tipe!="2" THEN tset_jumlah ELSE 0 END) AS total_objektif
                ', false)
                 ->where('tset_tes_id', $tes_id)
                 ->from('cbt_tes_topik_set');
        return $this->db->get();
    }

    function get_komposisi_soal_aktual($tes_id){
        $tesuser_sql = 'SELECT tesuser_id FROM cbt_tes_user WHERE tesuser_tes_id="'.$tes_id.'" ORDER BY tesuser_id DESC LIMIT 1';

        $this->db->select('
                    COUNT(*) AS total_soal,
                    SUM(CASE WHEN soal_tipe="2" THEN 1 ELSE 0 END) AS total_essay,
                    SUM(CASE WHEN soal_tipe!="2" THEN 1 ELSE 0 END) AS total_objektif
                ', false)
                 ->where('tessoal_tesuser_id = ('.$tesuser_sql.')')
                 ->from('cbt_tes_soal')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id');
        return $this->db->get();
    }

    function get_tesuser_by_tessoal($tessoal_id){
        $this->db->select('cbt_tes_user.tesuser_id, cbt_tes_user.tesuser_tes_id')
                 ->where('cbt_tes_soal.tessoal_id', $tessoal_id)
                 ->from('cbt_tes_soal')
                 ->join('cbt_tes_user', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->limit(1);
        return $this->db->get();
    }

    function get_komposisi_soal_by_tesuser($tesuser_id){
        $this->db->select('
                    COUNT(*) AS total_soal,
                    SUM(CASE WHEN soal_tipe="2" THEN 1 ELSE 0 END) AS total_essay,
                    SUM(CASE WHEN soal_tipe!="2" THEN 1 ELSE 0 END) AS total_objektif
                ', false)
                 ->where('tessoal_tesuser_id', $tesuser_id)
                 ->from('cbt_tes_soal')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id');
        return $this->db->get();
    }

    function get_datatable_evaluasi_count($tes_id, $order){
        $sql = '';
        if(!empty($tes_id)){
            $sql = ' AND tesuser_tes_id="'.$tes_id.'"';
        }

        $this->db->select('COUNT(*) AS hasil')
                 ->where('(soal_tipe="2" AND tessoal_jawaban_text IS NOT NULL AND tessoal_comment IS NULL '.$sql.' )')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->join('cbt_soal', 'cbt_tes_soal.tessoal_soal_id = cbt_soal.soal_id')
                 ->from($this->table);
        return $this->db->get();
    }

    /**
     * Datatable untuk hasil tes operator
     *
     * @param      <type>  $start  The start
     * @param      <type>  $rows   The rows
     * @param      <type>  $token  The token
     *
     * @return     <type>  The datatable.
     */
    function get_datatable_operator($start, $rows, $token){
        $this->db->select('cbt_tes_user.*,cbt_user_grup.grup_nama, cbt_tes.*, cbt_user.*, SUM(`cbt_tes_soal`.`tessoal_nilai`) AS nilai ')
                 ->where('(tesuser_token IN ('.$token.'))')
                 ->from($this->table)
                 ->join('cbt_user', 'cbt_tes_user.tesuser_user_id = cbt_user.user_id')
                 ->join('cbt_user_grup', 'cbt_user.user_grup_id = cbt_user_grup.grup_id')
                 ->join('cbt_tes', 'cbt_tes_user.tesuser_tes_id = cbt_tes.tes_id')
                 ->join('cbt_tes_soal', 'cbt_tes_soal.tessoal_tesuser_id = cbt_tes_user.tesuser_id')
                 ->group_by('cbt_tes_user.tesuser_id')
                 ->order_by('tesuser_creation_time DESC')
                 ->limit($rows, $start);
        return $this->db->get();
    }
    
    function get_datatable_operator_count($token){
        $this->db->select('COUNT(*) AS hasil')
                 ->where('(tesuser_token IN ('.$token.'))')
                 ->from($this->table);
        return $this->db->get();
    }
}
