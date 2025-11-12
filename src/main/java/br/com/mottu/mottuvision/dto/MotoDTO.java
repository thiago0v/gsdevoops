package br.com.mottu.mottuvision.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;

/**
 * DTO para transferência de dados de Moto via API REST
 */
public class MotoDTO {
    
    private Long id;
    private String placa;
    private String modelo;
    private Integer ano;
    private Long filialId;
    private String filialNome;
    private String status;
    private Integer posicaoX;
    private Integer posicaoY;
    
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss")
    private LocalDateTime ultimaAtualizacao;

    // Construtores
    public MotoDTO() {
    }

    public MotoDTO(Long id, String placa, String modelo, Integer ano, Long filialId, 
                   String filialNome, String status, Integer posicaoX, Integer posicaoY, 
                   LocalDateTime ultimaAtualizacao) {
        this.id = id;
        this.placa = placa;
        this.modelo = modelo;
        this.ano = ano;
        this.filialId = filialId;
        this.filialNome = filialNome;
        this.status = status;
        this.posicaoX = posicaoX;
        this.posicaoY = posicaoY;
        this.ultimaAtualizacao = ultimaAtualizacao;
    }

    // Getters e Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPlaca() {
        return placa;
    }

    public void setPlaca(String placa) {
        this.placa = placa;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public Integer getAno() {
        return ano;
    }

    public void setAno(Integer ano) {
        this.ano = ano;
    }

    public Long getFilialId() {
        return filialId;
    }

    public void setFilialId(Long filialId) {
        this.filialId = filialId;
    }

    public String getFilialNome() {
        return filialNome;
    }

    public void setFilialNome(String filialNome) {
        this.filialNome = filialNome;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getPosicaoX() {
        return posicaoX;
    }

    public void setPosicaoX(Integer posicaoX) {
        this.posicaoX = posicaoX;
    }

    public Integer getPosicaoY() {
        return posicaoY;
    }

    public void setPosicaoY(Integer posicaoY) {
        this.posicaoY = posicaoY;
    }

    public LocalDateTime getUltimaAtualizacao() {
        return ultimaAtualizacao;
    }

    public void setUltimaAtualizacao(LocalDateTime ultimaAtualizacao) {
        this.ultimaAtualizacao = ultimaAtualizacao;
    }

    @Override
    public String toString() {
        return "MotoDTO{" +
                "id=" + id +
                ", placa='" + placa + '\'' +
                ", modelo='" + modelo + '\'' +
                ", ano=" + ano +
                ", filialId=" + filialId +
                ", filialNome='" + filialNome + '\'' +
                ", status='" + status + '\'' +
                ", posicaoX=" + posicaoX +
                ", posicaoY=" + posicaoY +
                ", ultimaAtualizacao=" + ultimaAtualizacao +
                '}';
    }
}
